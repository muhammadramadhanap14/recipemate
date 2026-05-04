class ChatMessage {
  final String text;
  final bool isUser;
  final List<String>? options;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.options,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}