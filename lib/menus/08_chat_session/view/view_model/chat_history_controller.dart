import 'package:get/get.dart';
import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/models/model/chat_session.dart';
import 'package:uuid/uuid.dart';

class ChatHistoryController extends GetxController {
  var sessions = <ChatSession>[].obs;

  final uuid = Uuid();

  /// CREATE NEW CHAT
  ChatSession createNewSession() {
    final session = ChatSession(
      id: uuid.v4(),
      title: "New Chat",
      messages: [],
      createdAt: DateTime.now(),
    );

    sessions.insert(0, session);
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
  }
}