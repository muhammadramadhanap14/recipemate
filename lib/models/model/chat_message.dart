class ChatMessage {
  final String text;
  final bool isUser;
  final List<String>? options;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.options,
  });
}