import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/models/model/chat_session.dart';
import 'package:recipemate/utils/auth_interceptor.dart';
import 'package:recipemate/utils/constant_url.dart';

class ChatApiRepository {
  late Dio _dio;

  ChatApiRepository() {
    final options = BaseOptions(
      baseUrl: ConstantUrl.openAiUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(minutes: 4),
      receiveTimeout: const Duration(minutes: 4),
      headers: {'Content-Type': 'application/json'},
    );

    _dio = Dio(options);
    _dio.interceptors.add(AuthInterceptor());
  }

  Future<List<ChatSession>> getChatSessions({
    bool includeMessages = true,
  }) async {
    try {
      final response = await _dio.get(
        '/chat/sessions',
        queryParameters: {'includeMessages': includeMessages},
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
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        rethrow;
      }
      rethrow;
    } catch (e) {
      debugPrint('ChatApiRepository: Failed to fetch chat sessions: $e');
      rethrow;
    }
  }

  Future<List<ChatMessage>> getChatMessages(
    String sessionId,
  ) async {
    try {
      final response = await _dio.get(
        '/chat/session/$sessionId/messages',
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
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        rethrow;
      }
      rethrow;
    } catch (e) {
      debugPrint(
        'ChatApiRepository: Failed to fetch chat messages for $sessionId: $e',
      );
      rethrow;
    }
  }

  Future<ChatSession?> getChatSession(String sessionId) async {
    try {
      final response = await _dio.get(
        '/chat/session/$sessionId',
      );

      final data = response.data;
      final sessionData = data is Map<String, dynamic> && data['data'] != null
          ? data['data']
          : data;

      if (sessionData is Map<String, dynamic>) {
        return ChatSession.fromJson(sessionData);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        rethrow;
      }
      log('Failed to fetch chat session $sessionId: $e');
      rethrow;
    } catch (e) {
      log('Failed to fetch chat session $sessionId: $e');
      rethrow;
    }
  }

  Future<bool> saveChatSession(
    String userId,
    ChatSession session,
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
      );

      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        rethrow;
      }
      log('Failed to save chat session: $e');
      return false;
    } catch (e) {
      log('Failed to save chat session: $e');
      return false;
    }
  }

  Future<bool> deleteChatSession(String sessionId) async {
    try {
      await _dio.delete(
        '/chat/session/$sessionId',
      );
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        rethrow;
      }
      log('Failed to delete chat session $sessionId: $e');
      return false;
    } catch (e) {
      log('Failed to delete chat session $sessionId: $e');
      return false;
    }
  }
}
