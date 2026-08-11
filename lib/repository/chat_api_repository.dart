import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/models/model/chat_session.dart';
import 'package:recipemate/utils/constant_url.dart';
import 'package:recipemate/utils/token_interceptor.dart';

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
    _dio.interceptors.add(TokenInterceptor());
  }

  Future<void> validateToken(String token) async {
    try {
      await _dio.get(
        '/chat/sessions',
        queryParameters: {'limit': 1},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      debugPrint("ChatApiRepository: validateToken check done");
    }
  }

  Future<List<ChatSession>> getChatSessions(
    String token, {
    bool includeMessages = true,
  }) async {
    try {
      final response = await _dio.get(
        '/chat/sessions',
        queryParameters: {'includeMessages': includeMessages},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint(
        "ChatApiRepository: getChatSessions raw response: ${response.data}",
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
    } on DioException catch (e) {
      debugPrint(
        'ChatApiRepository: Failed to fetch chat sessions: ${e.response?.statusCode} ${e.response?.data}',
      );
      return [];
    } catch (e) {
      debugPrint('ChatApiRepository: Failed to fetch chat sessions: $e');
      return [];
    }
  }

  Future<List<ChatMessage>> getChatMessages(
    String sessionId,
    String token,
  ) async {
    try {
      final response = await _dio.get(
        '/chat/session/$sessionId/messages',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint(
        "ChatApiRepository: getChatMessages for $sessionId raw response: ${response.data}",
      );

      final data = response.data;
      final rawList = data is List
          ? data
          : data is Map<String, dynamic> && data['data'] is List
          ? data['data']
          : data is Map<String, dynamic> && data['messages'] is List
          ? data['messages']
          : null;

      if (rawList is List) {
        return rawList
            .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint(
        'ChatApiRepository: Failed to fetch chat messages for $sessionId: ${e.response?.statusCode} ${e.response?.data}',
      );
      return [];
    } catch (e) {
      debugPrint(
        'ChatApiRepository: Failed to fetch chat messages for $sessionId: $e',
      );
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
      final sessionData = data is Map<String, dynamic> && data['data'] != null
          ? data['data']
          : data;

      if (sessionData is Map<String, dynamic>) {
        return ChatSession.fromJson(sessionData);
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

  Future<bool> deleteChatSession(String sessionId, String token) async {
    try {
      await _dio.delete(
        '/chat/session/$sessionId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return true;
    } catch (e) {
      log('Failed to delete chat session $sessionId: $e');
      return false;
    }
  }
}
