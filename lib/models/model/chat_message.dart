import 'dart:convert';

class ChatMessage {
  final String text;
  final bool isUser;
  final List<String>? options;
  final int? stepIndex;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.options,
    this.stepIndex,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'options': options,
      'stepIndex': stepIndex,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    // Handle 'role' from backend if 'isUser' is not present
    bool isUser = json['isUser'] ?? (json['role'] == 'user');

    return ChatMessage(
      text: (json['text'] ?? json['content'] ?? '') as String,
      isUser: isUser,
      options: json['options'] != null
          ? List<String>.from(json['options'] as List)
          : null,
      stepIndex: json['stepIndex'] is int ? json['stepIndex'] as int : null,
      timestamp: json['timestamp'] is int
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int)
          : json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
