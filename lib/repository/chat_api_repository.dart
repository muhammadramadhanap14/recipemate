import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:recipemate/models/model/chat_session.dart';
import 'package:recipemate/utils/constant_url.dart';

class ChatApiRepository {
  late Dio _dio;

  ChatApiRepository() {
    final options = BaseOptions(
      baseUrl: ConstantUrl.recipemateUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(minutes: 4),
      receiveTimeout: const Duration(minutes: 4),
      headers: {'Content-Type': 'application/json'},
    );

    _dio = Dio(options);
  }

  Future<List<ChatSession>> getChatSessions(String token) async {
    try {
      final response = await _dio.get(
        '/chat/sessions',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data;
      final rawList = data is List
          ? data
          : data is Map<String, dynamic> && data['data'] is List
          ? data['data']
          : data is Map<String, dynamic> && data['sessions'] is List
          ? data['sessions']
          : null;
      if (rawList is List) {
        return rawList
            .map((item) => ChatSession.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      log('Failed to fetch chat sessions: $e');
      return [];
    }
  }

  Future<ChatSession?> getChatSession(String sessionId, String token) async {
    try {
      final response = await _dio.get(
        '/chat/session/$sessionId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ChatSession.fromJson(data);
      }
      return null;
    } catch (e) {
      log('Failed to fetch chat session $sessionId: $e');
      return null;
    }
  }

  Future<bool> saveChatSession(
    String userId,
    ChatSession session,
    String token,
  ) async {
    try {
      final payload = {
        'id': session.id,
        'userId': userId,
        'title': session.title,
        'createdAt': session.createdAt.toIso8601String(),
        'messages': session.messages.map((message) {
          return {
            'text': message.text,
            'role': message.isUser ? 'user' : 'assistant',
            'options': message.options,
            'timestamp': message.timestamp.millisecondsSinceEpoch,
          };
        }).toList(),
      };

      await _dio.post(
        '/chat/session',
        data: payload,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return true;
    } catch (e) {
      log('Failed to save chat session: $e');
      return false;
    }
  }
}
