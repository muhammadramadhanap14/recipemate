import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/models/model/chat_session.dart';
import 'package:recipemate/repository/realtime_paths.dart';

class ChatRealtimeRepository {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Future<void> createSessionWithSpecificId(String sessionId, String title, String userMessage) async {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint("DEBUG RTDB createSession: uid=${user?.uid}, emailVerified=${user?.emailVerified}");

    final now = ServerValue.timestamp;
    final messagesRef = _db.ref(RealtimePaths.chatMessages(sessionId));
    final msgRef = messagesRef.push();

    final lastMsg = userMessage.length > 120 ? '${userMessage.substring(0, 117)}...' : userMessage;

    final Map<String, dynamic> updates = {};
    updates[RealtimePaths.chatSession(sessionId)] = {
      'title': title,
      'createdAt': now,
      'updatedAt': now,
      'lastMessage': lastMsg,
    };
    updates['${RealtimePaths.chatMessages(sessionId)}/${msgRef.key}'] = {
      'role': 'user',
      'content': userMessage,
      'createdAt': now,
    };

    debugPrint("DEBUG RTDB updates: $updates");

    try {
      await _db.ref().update(updates);
      _db.ref(RealtimePaths.chatSession(sessionId)).keepSynced(true);
    } catch (e) {
      debugPrint("DEBUG RTDB ERROR: $e");
      rethrow;
    }
  }

  Future<void> addMessage(String sessionId, String role, String content) async {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint("DEBUG RTDB addMessage: uid=${user?.uid}, emailVerified=${user?.emailVerified}");

    final messagesRef = _db.ref(RealtimePaths.chatMessages(sessionId));
    final newMessageRef = messagesRef.push();
    final now = ServerValue.timestamp;

    final lastMsg = content.length > 120 ? '${content.substring(0, 117)}...' : content;

    final Map<String, dynamic> updates = {};
    updates['${RealtimePaths.chatMessages(sessionId)}/${newMessageRef.key}'] = {
      'role': role,
      'content': content,
      'createdAt': now,
    };
    updates['${RealtimePaths.chatSession(sessionId)}/updatedAt'] = now;
    updates['${RealtimePaths.chatSession(sessionId)}/lastMessage'] = lastMsg;

    debugPrint("DEBUG RTDB addMessage updates: $updates");

    try {
      await _db.ref().update(updates);
    } catch (e) {
      debugPrint("DEBUG RTDB addMessage ERROR: $e");
      rethrow;
    }
  }

  Stream<List<ChatSession>> watchSessions() {
    try {
      final sessionsRef = _db.ref(RealtimePaths.chatSessions()).orderByChild('updatedAt');
      sessionsRef.keepSynced(true);
      return sessionsRef.onValue.map((event) {
        final data = event.snapshot.value;
        if (data == null || data is! Map) return [];

        final list = <ChatSession>[];
        data.forEach((key, value) {
          if (value is Map) {
            final map = Map<String, dynamic>.from(value);
            map['id'] = key;
            list.add(ChatSession.fromJson(map));
          }
        });
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      });
    } catch (_) {
      return Stream.value([]);
    }
  }

  Future<List<ChatMessage>> loadMessages(String sessionId) async {
    final snapshot = await _db.ref(RealtimePaths.chatMessages(sessionId)).get();
    final data = snapshot.value;
    if (data == null || data is! Map) return [];

    final list = <ChatMessage>[];
    data.forEach((key, value) {
      if (value is Map) {
        final map = Map<String, dynamic>.from(value);
        list.add(ChatMessage.fromJson(map));
      }
    });
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }

  Future<void> updateSessionTitle(String sessionId, String title) async {
    await _db.ref('${RealtimePaths.chatSession(sessionId)}/title').set(title);
  }

  Future<void> deleteSession(String sessionId) async {
    final Map<String, dynamic> updates = {};
    updates[RealtimePaths.chatSession(sessionId)] = null;
    updates[RealtimePaths.chatMessages(sessionId)] = null;
    await _db.ref().update(updates);
  }
}
