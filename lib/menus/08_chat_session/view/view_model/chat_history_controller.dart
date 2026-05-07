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
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final token = _sessionController.stToken.value;
    if (token.isEmpty) return;

    final loaded = await _chatApi.getChatSessions(token);
    if (loaded.isNotEmpty) {
      sessions.assignAll(loaded);
    }
  }

  /// CREATE NEW CHAT
  ChatSession createNewSession() {
    final session = ChatSession(
      id: uuid.v4(),
      title: "New Chat",
      messages: [ChatMessage(text: _initialAiGreeting, isUser: false)],
      createdAt: DateTime.now(),
    );

    sessions.insert(0, session);
    _saveSession(session);
    return session;
  }

  /// UPDATE SESSION
  void updateSession(ChatSession session, List<ChatMessage> messages) {
    session.messages.clear();
    session.messages.addAll(messages);

    /// update title dari message pertama
    if (messages.isNotEmpty) {
      session.title = messages.first.text;
    }

    sessions.refresh();
    _saveSession(session);
  }

  Future<void> _saveSession(ChatSession session) async {
    final token = _sessionController.stToken.value;
    final userId = _sessionController.stUserId.value;
    if (token.isEmpty || userId.isEmpty) return;

    await _chatApi.saveChatSession(userId, session, token);
  }
}
