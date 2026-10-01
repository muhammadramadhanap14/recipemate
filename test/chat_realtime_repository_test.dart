import 'package:flutter_test/flutter_test.dart';
import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/models/model/chat_session.dart';

void main() {
  group('Chat Model Serialization Tests', () {
    test('ChatMessage toJson and fromJson work correctly', () {
      final msg = ChatMessage(text: 'Hello AI', isUser: true);
      final json = msg.toJson();

      expect(json['text'], 'Hello AI');
      expect(json['isUser'], true);
      expect(json['timestamp'], isNotNull);

      final reconstructed = ChatMessage.fromJson(json);
      expect(reconstructed.text, 'Hello AI');
      expect(reconstructed.isUser, true);
    });

    test('ChatSession toJson and fromJson work correctly', () {
      final session = ChatSession(
        id: 'session-123',
        title: 'Test Session',
        messages: [ChatMessage(text: 'Hi', isUser: true)],
        createdAt: DateTime(2026, 1, 1),
      );

      final json = session.toJson();
      expect(json['id'], 'session-123');
      expect(json['title'], 'Test Session');
      expect(json['messages'], isA<List>());

      final reconstructed = ChatSession.fromJson(json);
      expect(reconstructed.id, 'session-123');
      expect(reconstructed.title, 'Test Session');
      expect(reconstructed.messages.length, 1);
    });
  });
}
