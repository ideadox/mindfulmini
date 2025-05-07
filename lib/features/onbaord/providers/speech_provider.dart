import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechProvider with ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';

  bool get isListening => _isListening;
  String get text => _text;

  String? _error;

  String? get error => _error;
  Future<void> initSpeech() async {
    await _speech.initialize(
      onStatus: (val) {
        log(val);
        if (val == 'notListening' || val == 'done') {
          _isListening = false;
          notifyListeners();
        } else if (val == 'listening') {
          _isListening = true;
          notifyListeners();
        }
      },
      onError: (val) {
        log(val.errorMsg);
        _error = val.errorMsg;
        _isListening = false;
        notifyListeners();
      },
    );
  }

  void startListening() async {
    if (!_isListening) {
      _speech.listen(
        onResult: (val) {
          if (val.finalResult) {
            _text += ' ${val.recognizedWords}';
          }

          notifyListeners();
        },
      );
    }
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
    }
  }

  void toggleListening() {
    _isListening ? stopListening() : startListening();
  }

  void clear() {
    _text = '';
    notifyListeners();
  }
}
