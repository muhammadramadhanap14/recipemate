import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:recipemate/menus/07_chat/view/view_model/chat_view_model.dart';

class ChatView extends StatelessWidget {
  final controller = Get.put(ChatViewModel());
  final inputController = TextEditingController();

  ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,

      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "RecipeMate AI",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
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
                  if (msg.options != null && msg.options!.isNotEmpty) {
                    print('Options: ${msg.options}');
                  }
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
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: controller.startCooking,
                child: Text(
                  "Start Cooking",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
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
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                              horizontal: 18,
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
