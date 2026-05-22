import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:recipemate/menus/07_chat_session/view/view_model/chat_history_controller.dart';

import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/models/model/chat_session.dart';
import 'package:recipemate/utils/constant_url.dart';

const String _initialAiGreeting =
    "Halo! Saya RecipeMate AI. Selamat datang di asisten memasakmu. Mau cari resep, minta ide menu, atau langsung tanya tips dapur?";

class ChatViewModel extends GetxController {
  /// SESSION (🔥 NEW)
  final ChatSession session;

  ChatViewModel({required this.session});

  /// CHAT
  var messages = <ChatMessage>[].obs;
  var isLoading = false.obs;
  var isReady = false.obs;

  /// COOKING STATE
  var isCooking = false.obs;
  var steps = <String>[].obs;
  var currentStep = 0.obs;
  var recipeName = "".obs;

  /// TIMER STATE
  var remainingSeconds = 0.obs;
  var isTimerRunning = false.obs;
  var activeTimerStepIndex = (-1).obs;
  var stepRemainingSeconds = <int, int>{}.obs;

  Timer? timer;

  final baseUrl = ConstantUrl.recipemateBaseUrl;

  Uri _chatUri(String path) => Uri.parse('$baseUrl$path');

  String _extractBackendError(String body, int statusCode) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] != null) return decoded['message'].toString();
        if (decoded['error'] != null) return decoded['error'].toString();
        if (decoded['detail'] != null) return decoded['detail'].toString();
      }
    } catch (_) {}
    if (body.isNotEmpty) return body;
    return 'Status code $statusCode';
  }

  /// =========================
  /// INIT (LOAD HISTORY)
  /// =========================
  @override
  void onInit() {
    super.onInit();

    /// load existing messages dari session
    messages.assignAll(session.messages);

    /// Jika sesi baru belum memiliki pesan, tambahkan greeting AI langsung.
    if (messages.isEmpty) {
      messages.add(ChatMessage(text: _initialAiGreeting, isUser: false));
      _saveToHistory();
    }
  }

  /// =========================
  /// SEND MESSAGE (CHAT)
  /// =========================
  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    messages.add(ChatMessage(text: text, isUser: true));

    // Handle Cooking Navigation via Quick Replies
    if (isCooking.value) {
      if (text == "Sudah") {
        nextStep();
        return;
      }

      if (text == "Belum") {
        // Repeat the current step and remove the old confirmation prompt.
        _clearOptionsForStep(currentStep.value);

        final currentStepText = steps.isNotEmpty
            ? steps[currentStep.value]
            : "Silakan lanjutkan saat kamu siap.";
        messages.add(
          ChatMessage(
            text: currentStepText,
            isUser: false,
            stepIndex: currentStep.value,
          ),
        );
        messages.add(
          ChatMessage(
            text: "Lanjut ke langkah berikutnya?",
            isUser: false,
            options: ["Sudah", "Belum"],
            stepIndex: currentStep.value,
          ),
        );
        _saveToHistory();
        return;
      }

      messages.add(
        ChatMessage(
          text:
              "Selesaikan resep yang sedang berjalan dulu, baru bisa chat lagi.",
          isUser: false,
        ),
      );
      _saveToHistory();
      return;
    }

    isLoading.value = true;

    try {
      final uri = _chatUri(ConstantUrl.chatEndpoint);
      final payload = jsonEncode({
        "messages": messages
            .map(
              (e) => {
                "role": e.isUser ? "user" : "assistant",
                "content": e.text,
              },
            )
            .toList(),
      });

      debugPrint('ChatViewModel sendMessage URL: $uri');
      debugPrint('ChatViewModel sendMessage body: $payload');
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      debugPrint('ChatViewModel sendMessage status: ${response.statusCode}');
      debugPrint('ChatViewModel sendMessage response: ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final errorMessage = _extractBackendError(
          response.body,
          response.statusCode,
        );
        messages.add(
          ChatMessage(
            text: "Gagal mengirim pesan: $errorMessage",
            isUser: false,
          ),
        );
        return;
      }

      final data = jsonDecode(response.body);

      if (data["ready"] == true) {
        isReady.value = true;

        messages.add(ChatMessage(text: data["message"], isUser: false));
      } else {
        messages.add(
          ChatMessage(
            text: data["reply"],
            isUser: false,
            options: data["options"] != null
                ? List<String>.from(data["options"])
                : null,
          ),
        );
      }
    } catch (e) {
      messages.add(ChatMessage(text: "Error: $e", isUser: false));
    }

    isLoading.value = false;

    /// 🔥 SAVE TO HISTORY
    _saveToHistory();
  }

  /// =========================
  /// START COOKING
  /// =========================
  Future<void> startCooking() async {
    try {
      final uri = _chatUri(ConstantUrl.generateRecipeEndpoint);
      final payload = jsonEncode({
        "context": messages.map((e) => e.text).join(" "),
      });

      debugPrint('ChatViewModel startCooking URL: $uri');
      debugPrint('ChatViewModel startCooking body: $payload');
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      debugPrint('ChatViewModel startCooking status: ${response.statusCode}');
      debugPrint('ChatViewModel startCooking response: ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final errorMessage = _extractBackendError(
          response.body,
          response.statusCode,
        );
        messages.add(
          ChatMessage(
            text: "Gagal generate resep: $errorMessage",
            isUser: false,
          ),
        );
        return;
      }

      final data = jsonDecode(response.body);
      final recipe = data["recipe"];

      recipeName.value = recipe["name"];
      steps.value = List<String>.from(recipe["steps"]);
      currentStep.value = 0;
      isCooking.value = true;

      messages.add(
        ChatMessage(
          text: "Kita mulai masak ${recipeName.value} 👨‍🍳",
          isUser: false,
        ),
      );

      // Send first step
      messages.add(ChatMessage(text: steps[0], isUser: false, stepIndex: 0));

      // Send confirmation with quick reply
      messages.add(
        ChatMessage(
          text: "Lanjut ke langkah berikutnya?",
          isUser: false,
          options: ["Sudah", "Belum"],
          stepIndex: 0,
        ),
      );

      updateTimerForStep(0);
    } catch (e) {
      messages.add(ChatMessage(text: "Gagal generate resep 😢", isUser: false));
    }

    _saveToHistory();
  }

  /// =========================
  /// END COOKING
  /// =========================
  void endCooking() {
    timer?.cancel();
    isTimerRunning.value = false;
    remainingSeconds.value = 0;

    isCooking.value = false;
    isReady.value = false;
    steps.clear();
    currentStep.value = 0;
    recipeName.value = "";

    messages.add(
      ChatMessage(
        text: "Masak selesai! 🎉 Apakah anda ingin mencoba resep lain?",
        isUser: false,
      ),
    );

    _saveToHistory();
  }

  /// =========================
  /// NEXT STEP
  /// =========================
  void nextStep() {
    if (currentStep.value < steps.length - 1) {
      // clear options for the current step so previous widget disappears
      _clearOptionsForStep(currentStep.value);

      currentStep.value++;

      final stepText = steps[currentStep.value];

      messages.add(
        ChatMessage(
          text: stepText,
          isUser: false,
          stepIndex: currentStep.value,
        ),
      );

      // Add confirmation with quick reply (attach to this step)
      messages.add(
        ChatMessage(
          text: "Lanjut ke langkah berikutnya?",
          isUser: false,
          options: ["Sudah", "Belum"],
          stepIndex: currentStep.value,
        ),
      );

      updateTimerForStep(currentStep.value);
      _saveToHistory();
    } else {
      endCooking();
    }
  }

  void _clearOptionsForStep(int stepIndex) {
    // Remove confirmation message with options for the previous step
    messages.removeWhere(
      (m) =>
          !m.isUser &&
          m.stepIndex == stepIndex &&
          m.options != null &&
          m.options!.isNotEmpty &&
          m.text.contains("Lanjut ke"),
    );
  }

  /// =========================
  /// TIMER LOGIC
  /// =========================
  int extractTimeInSeconds(String step) {
    final regex = RegExp(r'(\d+)\s*(menit|detik)', caseSensitive: false);
    final match = regex.firstMatch(step);

    if (match != null) {
      final value = int.parse(match.group(1)!);
      final unit = match.group(2)!.toLowerCase();

      if (unit == "menit") return value * 60;
      if (unit == "detik") return value;
    }

    return 0;
  }

  void toggleTimerFromStep(int stepIndex) {
    final step = steps[stepIndex];
    final seconds = extractTimeInSeconds(step);

    if (seconds == 0) return;

    if (remainingSeconds.value == 0) {
      remainingSeconds.value = stepRemainingSeconds[stepIndex] ?? seconds;
    }

    if (isTimerRunning.value) {
      timer?.cancel();
      isTimerRunning.value = false;
    } else {
      isTimerRunning.value = true;

      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
          stepRemainingSeconds[stepIndex] = remainingSeconds.value;
        } else {
          t.cancel();
          isTimerRunning.value = false;
          stepRemainingSeconds[stepIndex] = 0;

          messages.add(ChatMessage(text: "⏰ Waktu selesai!", isUser: false));

          _saveToHistory();
        }
      });
    }
  }

  void updateTimerForStep(int stepIndex) {
    final step = steps[stepIndex];
    final seconds = extractTimeInSeconds(step);

    timer?.cancel();
    isTimerRunning.value = false;
    activeTimerStepIndex.value = stepIndex;

    if (seconds > 0) {
      remainingSeconds.value = seconds;
      stepRemainingSeconds[stepIndex] = seconds;
    } else {
      remainingSeconds.value = 0;
      stepRemainingSeconds.remove(stepIndex);
    }
  }

  /// =========================
  /// SAVE HISTORY 🔥
  /// =========================
  void _saveToHistory() {
    final historyController = Get.find<ChatHistoryController>();
    historyController.updateSession(session, messages);
  }
}
