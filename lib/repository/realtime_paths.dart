import 'package:firebase_auth/firebase_auth.dart';

class RealtimePaths {
  static String get currentUid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.uid;
  }

  static String chatSessions() => 'users/$currentUid/chat_sessions';
  static String chatSession(String sessionId) => 'users/$currentUid/chat_sessions/$sessionId';
  static String chatMessages(String sessionId) => 'users/$currentUid/chat_messages/$sessionId';
  static String favorites() => 'users/$currentUid/favorites';
  static String favorite(int recipeId) => 'users/$currentUid/favorites/$recipeId';
}
