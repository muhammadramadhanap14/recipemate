import 'dart:convert';

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

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'options': options,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      options: json['options'] != null
          ? List<String>.from(json['options'] as List)
          : null,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
