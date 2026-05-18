import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/models/model/chat_session.dart';
import 'package:recipemate/repository/chat_api_repository.dart';
import 'package:recipemate/utils/data_session_util_controller.dart';
import 'package:uuid/uuid.dart';

const String _initialAiGreeting =
    "Halo! Saya RecipeMate AI. Selamat datang di asisten memasakmu. Mau cari resep, minta ide menu, atau langsung tanya tips dapur?";

class ChatHistoryController extends GetxController {
  var sessions = <ChatSession>[].obs;

  final uuid = Uuid();
  late final ChatApiRepository _chatApi;
  late final DataSessionUtilController _sessionController;

  @override
  void onInit() {
    super.onInit();
    _chatApi = Get.find<ChatApiRepository>();
    _sessionController = Get.find<DataSessionUtilController>();

    // Initial load
    _loadSessions();

    // Listen for login/logout to refresh history
    ever(_sessionController.stToken, (String token) {
      if (token.isNotEmpty) {
        _loadSessions();
      } else {
        sessions.clear();
      }
    });
  }

  Future<void> _loadSessions() async {
    final token = _sessionController.stToken.value;
    if (token.isEmpty) return;

    if (kDebugMode) {
      print("ChatHistoryController: Loading sessions from API...");
    }
    final loaded = await _chatApi.getChatSessions(token);
    if (kDebugMode) {
      print("ChatHistoryController: Received ${loaded.length} sessions");
    }

    if (loaded.isNotEmpty) {
      for (var s in loaded) {
        if (kDebugMode) {
          print("Session ID: ${s.id}, Messages count: ${s.messages.length}");
        }
      }
      // Sort by date descending (newest first)
      loaded.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      sessions.assignAll(loaded);
    }
  }

  /// CREATE NEW CHAT
  ChatSession createNewSession() {
    return ChatSession(
      id: uuid.v4(),
      title: "New Chat",
      messages: [ChatMessage(text: _initialAiGreeting, isUser: false)],
      createdAt: DateTime.now(),
    );
  }

  /// UPDATE SESSION
  void updateSession(ChatSession session, List<ChatMessage> messages) {
    session.messages.clear();
    session.messages.addAll(messages);

    // Cek apakah ada pesan dari user
    final bool hasUserMessage = messages.any((m) => m.isUser);

    // Jika belum ada pesan user, jangan simpan dulu
    if (!hasUserMessage) return;

    /// update title dari message pertama user jika title masih "New Chat"
    if (session.title == "New Chat") {
      final userMsg = messages.firstWhereOrNull((m) => m.isUser);
      if (userMsg != null) {
        session.title = userMsg.text.length > 30
            ? "${userMsg.text.substring(0, 30)}..."
            : userMsg.text;
      }
    }

    // Masukkan ke list lokal jika belum ada (sesi baru)
    if (!sessions.any((s) => s.id == session.id)) {
      sessions.insert(0, session);
    }

    // Gunakan microtask untuk menghindari error "markNeedsBuild during build"
    // Ini memastikan UI diupdate setelah fase build selesai
    Future.microtask(() {
      sessions.refresh();
      _saveSession(session);
    });
  }

  Future<void> _saveSession(ChatSession session) async {
    final token = _sessionController.stToken.value;
    final userId = _sessionController.stUserId.value;
    if (token.isEmpty || userId.isEmpty) return;

    await _chatApi.saveChatSession(userId, session, token);
  }
}
