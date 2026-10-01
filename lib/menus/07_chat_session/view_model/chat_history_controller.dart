import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/models/model/chat_session.dart';
import 'package:recipemate/repository/chat_realtime_repository.dart';
import 'package:uuid/uuid.dart';

const String _initialAiGreeting =
    "Halo! Saya RecipeMate AI. Selamat datang di asisten memasakmu. Mau cari resep, minta ide menu, atau langsung tanya tips dapur?";

class ChatHistoryController extends GetxController {
  var sessions = <ChatSession>[].obs;

  final uuid = Uuid();
  late final ChatRealtimeRepository _chatRepo;
  StreamSubscription? _sessionsSubscription;

  @override
  void onInit() {
    super.onInit();
    _chatRepo = ChatRealtimeRepository();
    _initListener();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _sessionsSubscription?.cancel();
      if (user != null) {
        _initListener();
      } else {
        sessions.clear();
      }
    });
  }

  @override
  void onClose() {
    _sessionsSubscription?.cancel();
    super.onClose();
  }

  void _initListener() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final isEmailUser = user.providerData.any((p) => p.providerId == 'password');
      if (isEmailUser && !user.emailVerified) return;

      _sessionsSubscription = _chatRepo.watchSessions().listen((list) {
        sessions.assignAll(list);
      });
    } catch (e) {
      debugPrint("ChatHistoryController error listening sessions: $e");
    }
  }

  ChatSession createNewSession() {
    return ChatSession(
      id: uuid.v4(),
      title: "New Chat",
      messages: [ChatMessage(text: _initialAiGreeting, isUser: false)],
      createdAt: DateTime.now(),
    );
  }

  Future<void> deleteSession(ChatSession session) async {
    try {
      await _chatRepo.deleteSession(session.id);
      sessions.removeWhere((s) => s.id == session.id);
    } catch (e) {
      debugPrint("Error deleting session: $e");
    }
  }
}
