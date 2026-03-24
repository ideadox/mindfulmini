import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/sidhi/providers/shidi_chat_provider.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechProvider with ChangeNotifier {
  // SpeechToText() is a singleton (factory → same static instance).
  // We make this explicit with a shared static reference.
  static final stt.SpeechToText _speech = stt.SpeechToText();
  static bool _initialized = false;

  /// The provider that is currently listening. Only one can be active at a time
  /// because the platform speech engine is singular.
  static SpeechProvider? _activeProvider;

  final TextEditingController textController = TextEditingController();
  bool showIamListeningText = false;

  bool _isListening = false;
  bool get isListening => _isListening;

  /// Text that existed in the controller BEFORE the current listening session.
  /// Used to avoid duplication: on each onResult we set
  /// textController.text = _textBeforeListening + " " + recognizedWords
  String _textBeforeListening = '';

  // Stack to support undo/redo
  final List<String> _history = [];
  int _historyIndex = -1;

  String? _error;
  String? get error => _error;
  bool shidiChat = false;
  ShidiChatProvider? shidiChatProvider;

  bool isEmpty = true;

  void startLis() {
    textController.addListener(() {
      if (textController.text.isNotEmpty) {
        isEmpty = false;
        notifyListeners();
      } else {
        isEmpty = true;
        notifyListeners();
      }
    });
  }

  /// Ensures the speech engine is initialized exactly once.
  /// Returns false if speech recognition is unavailable or permission denied.
  static Future<bool> _ensureInitialized() async {
    if (_initialized) return true;
    try {
      _initialized = await _speech.initialize(
        onStatus: (val) {
          log('Speech status: $val');
          final provider = _activeProvider;
          if (provider == null) return;

          if (val == 'notListening' || val == 'done') {
            if (provider.shidiChat && val == 'done') {
              log('done called in shidi true ${provider.textController.text}');
              provider.shidiChatProvider!.messageController.text =
                  provider.textController.text;
              provider.textController.clear();
              sl<GoRouter>().pop(false);
              _activeProvider = null;
              return;
            }
            provider._isListening = false;
            _activeProvider = null;
            provider.notifyListeners();
          }
        },
        onError: (val) {
          log('Speech error: $val');
          final provider = _activeProvider;
          if (provider == null) return;
          provider._error = val.errorMsg;
          provider._isListening = false;
          _activeProvider = null;
          provider.notifyListeners();
        },
      );
    } catch (e) {
      log('Speech initialization failed: $e');
      _initialized = false;
    }
    return _initialized;
  }

  void addToHistory(String value) {
    if (_historyIndex == _history.length - 1) {
      _history.add(value);
      _historyIndex++;
    } else {
      _history.removeRange(_historyIndex + 1, _history.length);
      _history.add(value);
      _historyIndex = _history.length - 1;
    }
  }

  void startListening({
    bool shidi = false,
    ShidiChatProvider? scProvider,
  }) async {
    if (shidi) {
      shidiChat = shidi;
      shidiChatProvider = scProvider;
    }

    final available = await _ensureInitialized();
    if (!available) {
      // Retry once in case the user just granted permission
      _initialized = false;
      final retried = await _ensureInitialized();
      if (!retried) {
        _error = 'Speech recognition not available. Please check microphone permissions.';
        notifyListeners();
        return;
      }
    }

    // If another provider is currently listening, stop it first
    if (_activeProvider != null && _activeProvider != this) {
      _activeProvider!.stopListening();
    }

    if (!_isListening) {
      _activeProvider = this;
      _textBeforeListening = textController.text;
      _isListening = true;
      _error = null;
      notifyListeners();

      try {
        _speech.listen(
          onResult: (val) {
            log('Recognized: ${val.recognizedWords} (final: ${val.finalResult})');
            if (val.recognizedWords.isNotEmpty) {
              final separator = _textBeforeListening.isNotEmpty ? ' ' : '';
              final newText =
                  '$_textBeforeListening$separator${val.recognizedWords}'.trim();
              textController.text = newText;
              textController.selection = TextSelection.collapsed(
                offset: newText.length,
              );

              if (val.finalResult) {
                addToHistory(newText);
              }
              notifyListeners();
            }
          },
        );
        _handleListeningText();
      } catch (e) {
        log('Speech listen failed: $e');
        _error = 'Could not start speech recognition.';
        _isListening = false;
        _activeProvider = null;
        notifyListeners();
      }
    }
  }

  bool _disposed = false;

  _handleListeningText() {
    showIamListeningText = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      if (_disposed) return;
      showIamListeningText = false;
      notifyListeners();
    });
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
      if (_activeProvider == this) {
        _activeProvider = null;
      }
      notifyListeners();
    }
  }

  void toggleListening() {
    _isListening ? stopListening() : startListening();
  }

  void undo() {
    if (_historyIndex > 0) {
      _historyIndex--;
      textController.text = _history[_historyIndex];
      textController.selection = TextSelection.collapsed(
        offset: textController.text.length,
      );
      notifyListeners();
    }
  }

  void redo() {
    if (_historyIndex < _history.length - 1) {
      _historyIndex++;
      textController.text = _history[_historyIndex];
      textController.selection = TextSelection.collapsed(
        offset: textController.text.length,
      );
      notifyListeners();
    }
  }

  void clear() {
    textController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    if (_activeProvider == this) {
      _speech.stop();
      _activeProvider = null;
    }
    textController.dispose();
    super.dispose();
  }
}
