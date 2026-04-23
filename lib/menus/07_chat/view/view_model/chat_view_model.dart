import 'dart:async';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:recipemate/models/model/chat_message.dart';

class ChatViewModel extends GetxController {
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


      /// kirim ke chat
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

    /// 🔥 UPDATE TIMER
    updateTimerForStep(stepText);
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

    /// 🔥 UPDATE TIMER
    updateTimerForStep(stepText);
  }
}
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

  /// kalau belum pernah start → init
  if (remainingSeconds.value == 0) {
    remainingSeconds.value = seconds;
  }

  /// toggle logic
  if (isTimerRunning.value) {
    /// STOP
    timer?.cancel();
    isTimerRunning.value = false;
  } else {
    /// START
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
      }
    });
  }
}

void updateTimerForStep(String step) {
  final seconds = extractTimeInSeconds(step);

  /// stop timer lama
  timer?.cancel();
  isTimerRunning.value = false;

  if (seconds > 0) {
    /// ada timer → set waktu baru
    remainingSeconds.value = seconds;
  } else {
    /// tidak ada timer → hilangkan
    remainingSeconds.value = 0;
  }
}
}