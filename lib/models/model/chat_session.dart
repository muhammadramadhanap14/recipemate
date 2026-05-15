import 'dart:convert';

import 'package:recipemate/models/model/chat_message.dart';

class ChatSession {
  final String id;
  String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: (json['id'] ?? json['_id']) as String,
      title: (json['title'] ?? 'New Chat') as String,
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      createdAt: json['createdAt'] is int
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
