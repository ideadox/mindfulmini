import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class ShidiChatProvider with ChangeNotifier {
  TextEditingController messageController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isEmptyTextField = true;
  ShidiChatProvider() {
    _init();
  }

  void _init() {
    messageController.addListener(() {
      if (messageController.text.isNotEmpty) {
        if (isEmptyTextField == true) {
          isEmptyTextField = false;
          notifyListeners();
        }
      } else {
        if (isEmptyTextField == false) {
          isEmptyTextField = true;
          notifyListeners();
        }
      }
    });
  }

  void focus() {
    focusNode.requestFocus();
  }

  void unfocus() {
    focusNode.unfocus();
  }

  final List<ChatMessage> sampleChatMessages = [
    ChatMessage(
      id: '1',
      sender: 'user',
      message: 'Hi there!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      id: '2',
      sender: 'bot',
      message: 'Hello! How can I assist you today?',
      timestamp: DateTime.now()
          .subtract(const Duration(minutes: 5))
          .add(const Duration(seconds: 10)),
    ),
    ChatMessage(
      id: '3',
      sender: 'user',
      message: 'What’s the weather like today?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    ChatMessage(
      id: '4',
      sender: 'bot',
      message: 'Checking the weather for your location...',
      timestamp: DateTime.now()
          .subtract(const Duration(minutes: 4))
          .add(const Duration(seconds: 8)),
      isTyping: true,
    ),
    ChatMessage(
      id: '5',
      sender: 'bot',
      message: 'It’s currently sunny with a high of 25°C.',
      timestamp:
          DateTime.now().subtract(const Duration(minutes: 3, seconds: 30)),
    ),
    ChatMessage(
      id: '6',
      sender: 'user',
      message: 'Thanks!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    ChatMessage(
      id: '7',
      sender: 'bot',
      message: 'You’re welcome! Let me know if you need anything else.',
      timestamp:
          DateTime.now().subtract(const Duration(minutes: 2, seconds: 45)),
    ),
  ];
}
