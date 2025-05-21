class ChatMessage {
  final String id;
  final String sender; // "user" or "bot"
  final String message;
  final DateTime timestamp;
  final bool isTyping;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.message,
    required this.timestamp,
    this.isTyping = false,
  });
}
