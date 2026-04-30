import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:recipemate/menus/07_chat/view/view_model/chat_view_model.dart';
import 'package:recipemate/menus/08_chat_session/view/view_model/chat_history_controller.dart';
import 'package:recipemate/models/model/chat_session.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.session, super.key});

  final ChatSession session;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final ChatViewModel controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(
      ChatViewModel(session: widget.session), // ✅ FIX
      tag: widget.session.id,
    );
  }

  late final inputController = TextEditingController();

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final historyController = Get.find<ChatHistoryController>();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  'Chat History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (historyController.sessions.isEmpty) {
                    return Center(
                      child: Text(
                        "Belum ada chat",
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: historyController.sessions.length,
                    itemBuilder: (context, index) {
                      final session = historyController.sessions[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          tileColor: isDark
                              ? const Color(0xFF1F1F28)
                              : const Color(0xFFF6F6FA),
                          title: Text(
                            session.title,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            session.createdAt.toString(),
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Future.delayed(
                              const Duration(milliseconds: 120),
                              () {
                                Get.offNamed('/chat', arguments: session);
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: isDark ? Colors.white : Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "RecipeMate AI",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Column(
        children: [
          /// =====================
          /// CHAT LIST
          /// =====================
          Expanded(
            child: Obx(
              () => ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages.reversed.toList()[index];
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;

                  return Align(
                    alignment: msg.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// AVATAR AI
                        if (!msg.isUser) ...[
                          Container(
                            margin: const EdgeInsets.only(right: 8, top: 8),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.12),
                              child: Icon(
                                Icons.smart_toy,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],

                        /// CHAT BUBBLE
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? Theme.of(context).colorScheme.primary
                                : isDark
                                ? const Color(0xFF2A2A2E)
                                : const Color(0xFFF1F1F5),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withValues(alpha: 0.2)
                                    : Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),

                          /// 🔥 ISI BUBBLE (TEXT + QUICK REPLY)
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// TEXT (MARKDOWN)
                              MarkdownBody(
                                data: msg.text,
                                styleSheet: MarkdownStyleSheet(
                                  p: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: msg.isUser
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  strong: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              /// 🔥 QUICK REPLY
                              if (!msg.isUser &&
                                  msg.options != null &&
                                  msg.options!.isNotEmpty) ...[
                                const SizedBox(height: 10),

                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: msg.options!.map((opt) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (controller.isLoading.value) return;
                                        controller.sendMessage(opt);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF3A3A5A)
                                              : const Color(0xFF6C63FF),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          opt,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          /// =====================
          /// START COOKING BUTTON
          /// =====================
          Obx(() {
            if (!controller.isReady.value || controller.isCooking.value) {
              return const SizedBox();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1F1F28)
                      : const Color(0xFFF8F8FC),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.15)
                          : Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ready to start cooking?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tekan tombol di bawah untuk mulai panduan memasak.",
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.local_fire_department, size: 18),
                        label: const Text("Start Cooking"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: controller.startCooking,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          /// =====================
          /// COOKING CONTROLS + TIMER
          /// =====================
          Obx(() {
            if (!controller.isCooking.value) {
              return const SizedBox();
            }

            final step = controller.steps[controller.currentStep.value];
            final seconds = controller.remainingSeconds.value;
            final minutes = seconds ~/ 60;
            final secs = seconds % 60;
            final totalSeconds = controller.extractTimeInSeconds(step);
            final hasTimer = totalSeconds > 0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasTimer) ...[
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          controller.toggleTimerFromStep(step);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 88,
                              height: 88,
                              child: CircularProgressIndicator(
                                value: totalSeconds > 0
                                    ? seconds / totalSeconds
                                    : 0,
                                strokeWidth: 6,
                                backgroundColor: isDark
                                    ? Colors.white12
                                    : Colors.black12,
                                valueColor: AlwaysStoppedAnimation(
                                  controller.isTimerRunning.value
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.primary
                                            .withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: controller.isTimerRunning.value
                                    ? Theme.of(context).colorScheme.primary
                                    : (isDark
                                          ? const Color(0xFF2A2A2E)
                                          : const Color(0xFFE0E0E0)),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    controller.isTimerRunning.value
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: controller.isTimerRunning.value
                                        ? Colors.white
                                        : isDark
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                      color: controller.isTimerRunning.value
                                          ? Colors.white
                                          : isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      /// PREVIOUS
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.prevStep,
                          icon: const Icon(Icons.arrow_back_ios, size: 16),
                          label: const Text("Previous"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark
                                ? Colors.white70
                                : Colors.black87,
                            side: BorderSide(
                              color: isDark ? Colors.white24 : Colors.black12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      /// 🔥 END COOKING (TENGAH)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text("Akhiri memasak?"),
                                content: const Text(
                                  "Progress kamu akan hilang",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.endCooking();
                                    },
                                    child: const Text("Ya"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.stop, size: 16),
                          label: const Text("End"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 4,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      /// NEXT
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: controller.nextStep,
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          label: const Text("Next"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          /// =====================
          /// INPUT
          /// =====================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2A2A2E)
                          : const Color(0xFFF3F3F7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: inputController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Ask ai chat anything",
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      controller.sendMessage(inputController.text);
                      inputController.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
