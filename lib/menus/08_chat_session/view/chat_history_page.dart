import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/menus/07_chat/view/chat_view.dart';
import 'package:recipemate/menus/08_chat_session/view/view_model/chat_history_controller.dart';

class ChatHistoryPage extends StatelessWidget {
  final controller = Get.put(ChatHistoryController());

  ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat History"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final session = controller.createNewSession();

          Get.toNamed(
  '/chat',
  arguments: session,
);
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.sessions.isEmpty) {
          return const Center(child: Text("Belum ada chat"));
        }

        return ListView.builder(
          itemCount: controller.sessions.length,
          itemBuilder: (context, index) {
            final session = controller.sessions[index];

            return ListTile(
              title: Text(session.title),
              subtitle: Text(
                session.createdAt.toString(),
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                Get.to(() => ChatView(session: session));
              },
            );
          },
        );
      }),
    );
  }
}