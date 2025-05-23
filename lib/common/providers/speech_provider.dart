import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/sidhi/providers/shidi_chat_provider.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechProvider with ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController textController = TextEditingController();
  bool showIamListeningText = false;

  bool _isListening = false;
  bool get isListening => _isListening;

  // Stack to support undo/redo
  final List<String> _history = [];
  int _historyIndex = -1;

  String? _error;
  String? get error => _error;
  bool shidiChat = false;
  ShidiChatProvider? shidiChatProvider;
  Future<void> initSpeech({
    bool shidi = false,
    ShidiChatProvider? scProvider,
  }) async {
    if (shidi) {
      shidiChat = shidi;
      shidiChatProvider = scProvider;
    }
    await _speech.initialize(
      onStatus: (val) {
        log('Speech status: $val');
        if (val == 'notListening') {
          _isListening = false;
          notifyListeners();
        } else if (val == 'listening') {
          _isListening = true;
          notifyListeners();
        } else if (val == 'done') {
          log('outside done');
          if (shidiChat) {
            log('done called in shsid true ${textController.text} value');
            shidiChatProvider!.messageController.text = textController.text;
            textController.clear;
            sl<GoRouter>().pop(false);
            return;
          }
          _isListening = false;
          notifyListeners();
        }
        log('staus comple');
      },
      onError: (val) {
        log('error : $val');
        _error = val.errorMsg;
        _isListening = false;
        notifyListeners();
      },
    );
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

  void startListening() async {
    // await initSpeech();
    if (!_isListening) {
      _speech.listen(
        onResult: (val) {
          log(val.recognizedWords.toString());
          if (val.recognizedWords.isNotEmpty) {
            final newText =
                '${textController.text} ${val.recognizedWords}'.trim();
            textController.text = newText;
            textController.selection = TextSelection.collapsed(
              offset: newText.length,
            );
            addToHistory(newText);
            notifyListeners();
          }
        },
      );
      _handleListeningText();
    }
  }

  _handleListeningText() {
    showIamListeningText = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      showIamListeningText = false;
      notifyListeners();
    });
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
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
    _speech.cancel();
    textController.dispose();
    super.dispose();
  }
}
