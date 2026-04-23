import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:recipemate/menus/08_chat_session/view/view_model/chat_history_controller.dart';
import 'dart:convert';

import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/models/model/chat_session.dart';

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

  Timer? timer;

  final baseUrl = "http://10.0.2.2:3000";

  /// =========================
  /// INIT (LOAD HISTORY)
  /// =========================
  @override
  void onInit() {
    super.onInit();

    /// load existing messages dari session
    messages.assignAll(session.messages);
  }

  /// =========================
  /// SEND MESSAGE (CHAT)
  /// =========================
  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    messages.add(ChatMessage(text: text, isUser: true));
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/chat"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "messages": messages.map((e) => {
                "role": e.isUser ? "user" : "assistant",
                "content": e.text,
              }).toList(),
        }),
      );

      final data = jsonDecode(response.body);

      if (data["ready"] == true) {
        isReady.value = true;

        messages.add(ChatMessage(
          text: data["message"],
          isUser: false,
        ));
      } else {
        messages.add(ChatMessage(
          text: data["reply"],
          isUser: false,
          options: data["options"] != null
              ? List<String>.from(data["options"])
              : null,
        ));
      }
    } catch (e) {
      messages.add(ChatMessage(
        text: "Error: $e",
        isUser: false,
      ));
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
      final response = await http.post(
        Uri.parse("$baseUrl/generate-recipe"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "context": messages.map((e) => e.text).join(" "),
        }),
      );

      final data = jsonDecode(response.body);
      final recipe = data["recipe"];

      recipeName.value = recipe["name"];
      steps.value = List<String>.from(recipe["steps"]);
      currentStep.value = 0;
      isCooking.value = true;

      if (steps.isNotEmpty) {
        updateTimerForStep(steps[0]);
      }

      messages.add(ChatMessage(
        text: "Kita mulai masak ${recipeName.value} 👨‍🍳",
        isUser: false,
      ));

      messages.add(ChatMessage(
        text: steps[0],
        isUser: false,
      ));
    } catch (e) {
      messages.add(ChatMessage(
        text: "Gagal generate resep 😢",
        isUser: false,
      ));
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
    steps.clear();
    currentStep.value = 0;
    recipeName.value = "";

    messages.add(ChatMessage(
      text: "Masak selesai! 🎉 Mau coba resep lain?",
      isUser: false,
    ));

    _saveToHistory();
  }

  /// =========================
  /// NEXT STEP
  /// =========================
  void nextStep() {
    if (currentStep.value < steps.length - 1) {
      currentStep.value++;

      final stepText = steps[currentStep.value];

      messages.add(ChatMessage(
        text: stepText,
        isUser: false,
      ));

      updateTimerForStep(stepText);
      _saveToHistory();
    }
  }

  /// =========================
  /// PREVIOUS STEP
  /// =========================
  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;

      final stepText = steps[currentStep.value];

      messages.add(ChatMessage(
        text: "Kembali ke langkah sebelumnya:\n$stepText",
        isUser: false,
      ));

      updateTimerForStep(stepText);
      _saveToHistory();
    }
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

  void toggleTimerFromStep(String step) {
    final seconds = extractTimeInSeconds(step);

    if (seconds == 0) return;

    if (remainingSeconds.value == 0) {
      remainingSeconds.value = seconds;
    }

    if (isTimerRunning.value) {
      timer?.cancel();
      isTimerRunning.value = false;
    } else {
      isTimerRunning.value = true;

      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          t.cancel();
          isTimerRunning.value = false;

          messages.add(ChatMessage(
            text: "⏰ Waktu selesai!",
            isUser: false,
          ));

          _saveToHistory();
        }
      });
    }
  }

  void updateTimerForStep(String step) {
    final seconds = extractTimeInSeconds(step);

    timer?.cancel();
    isTimerRunning.value = false;

    if (seconds > 0) {
      remainingSeconds.value = seconds;
    } else {
      remainingSeconds.value = 0;
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