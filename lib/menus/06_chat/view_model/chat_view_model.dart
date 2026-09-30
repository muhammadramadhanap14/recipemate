import 'dart:async';
import 'dart:developer' as dev;

import 'package:get/get.dart';

import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/models/model/chat_session.dart';
import 'package:recipemate/services/openai_service.dart';
import 'package:recipemate/utils/notification_util.dart';
import 'package:vibration/vibration.dart';

import '../../../../repository/chat_api_repository.dart';
import '../../../../utils/data_session_util.dart';
import '../../../../utils/data_session_util_controller.dart';
import '../../07_chat_session/view_model/chat_history_controller.dart';

const String _initialAiGreeting =
    "Halo! Saya RecipeMate AI. Selamat datang di asisten memasakmu. Mau cari resep, minta ide menu, atau langsung tanya tips dapur?";

class ChatViewModel extends GetxController {
  /// SESSION
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

  final OpenAiService _openAiService = OpenAiService();

  String _sanitizeQuickReply(String option) {
    return option.replaceAll(RegExp(r'(\*\*|\*|__|_)'), '').trim();
  }

  List<String> _sanitizeQuickReplies(List<dynamic> options) {
    return options
        .map((item) => _sanitizeQuickReply(item.toString()))
        .where((value) => value.isNotEmpty)
        .toList();
  }

  /// =========================
  /// INIT (LOAD HISTORY)
  /// =========================
  @override
  Future<void> onInit() async {
    super.onInit();

    final sessionUtil = Get.find<DataSessionUtil>();
    await sessionUtil.setCurrentChatSessionId(
      session.id,
    );

    dev.log("ChatViewModel: Initializing with session ID: ${session.id}");
    dev.log("ChatViewModel: Session has ${session.messages.length} messages");

    /// load existing messages dari session
    if (session.messages.isNotEmpty) {
      messages.assignAll(session.messages);
      dev.log(
        "ChatViewModel: Loaded ${messages.length} messages into observable list",
      );
    }

    // Selalu coba muat pesan terbaru dari server untuk memastikan data sinkron
    _fetchLatestMessages();
  }

  Future<void> _fetchLatestMessages() async {
    // Jika ini sesi baru (ID UUID v4), tidak perlu fetch ke server dulu
    if (messages.isEmpty && session.title == "New Chat") {
      messages.add(ChatMessage(text: _initialAiGreeting, isUser: false));
      Future.microtask(() => _saveToHistory());
      return;
    }

    isLoading.value = true;
    try {
      final token = Get.find<DataSessionUtilController>().stToken.value;
      final historyController = Get.find<ChatHistoryController>();
      final chatApi = Get.find<ChatApiRepository>();

      dev.log("ChatViewModel: Fetching latest messages for ${session.id}");
      final remoteMessages = await chatApi.getChatMessages(session.id, token);

      if (remoteMessages.isNotEmpty) {
        dev.log(
          "ChatViewModel: Received ${remoteMessages.length} messages from server",
        );
        messages.assignAll(remoteMessages);

        // Sync balik ke objek session lokal
        session.messages.clear();
        session.messages.addAll(remoteMessages);
        historyController.sessions.refresh();
      } else if (messages.isEmpty) {
        dev.log("ChatViewModel: No messages found on server, adding greeting");
        messages.add(ChatMessage(text: _initialAiGreeting, isUser: false));
        _saveToHistory();
      }
    } catch (e) {
      dev.log("ChatViewModel: Error fetching messages: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// SEND MESSAGE (CHAT VIA OPENAI)
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
      final response = await _openAiService.sendChatMessage(messages);

      if (response.ready) {
        isReady.value = true;
        messages.add(ChatMessage(text: response.reply, isUser: false));
      } else {
        messages.add(
          ChatMessage(
            text: response.reply,
            isUser: false,
            options: response.options != null
                ? _sanitizeQuickReplies(response.options!)
                : null,
          ),
        );
      }
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      messages.add(ChatMessage(text: "Gagal mengirim pesan: $message", isUser: false));
    }

    isLoading.value = false;

    /// SAVE TO HISTORY
    _saveToHistory();
  }

  /// =========================
  /// START COOKING (GENERATE RESEP VIA OPENAI)
  /// =========================
  Future<void> startCooking() async {
    isLoading.value = true;
    try {
      final recipeResponse = await _openAiService.generateRecipe(messages);

      recipeName.value = recipeResponse.name;
      steps.value = recipeResponse.steps;
      currentStep.value = 0;
      isCooking.value = true;

      if (steps.isNotEmpty) {
        updateTimerForStep(steps[0]);
      }

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
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      messages.add(ChatMessage(text: "Gagal generate resep: $message 😢", isUser: false));
    } finally {
      isLoading.value = false;
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
    NotificationUtil.cancelTimerNotifications();

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

      // Add confirmation with quick reply
      messages.add(
        ChatMessage(
          text: "Lanjut ke langkah berikutnya?",
          isUser: false,
          options: ["Sudah", "Belum"],
          stepIndex: currentStep.value,
        ),
      );

      updateTimerForStep(stepText);
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

  void toggleTimerFromStep(String step) {
    final seconds = extractTimeInSeconds(step);

    if (seconds == 0) return;

    if (remainingSeconds.value == 0) {
      remainingSeconds.value = seconds;
    }

    if (isTimerRunning.value) {
      timer?.cancel();
      isTimerRunning.value = false;
      NotificationUtil.cancelTimerNotifications();
    } else {
      isTimerRunning.value = true;
      NotificationUtil.showTimerNotification(remainingSeconds.value, recipeName.value);
      NotificationUtil.scheduleTimerFinishedNotification(remainingSeconds.value, recipeName.value);

      timer = Timer.periodic(const Duration(seconds: 1), (t) async {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          t.cancel();
          isTimerRunning.value = false;

          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 1000);
          }
          NotificationUtil.cancelTimerNotifications();

          messages.add(ChatMessage(text: "⏰ Waktu selesai!", isUser: false));

          _saveToHistory();
        }
      });
    }
  }

  void updateTimerForStep(String step) {
    final seconds = extractTimeInSeconds(step);

    timer?.cancel();
    isTimerRunning.value = false;
    NotificationUtil.cancelTimerNotifications();

    if (seconds > 0) {
      remainingSeconds.value = seconds;
    } else {
      remainingSeconds.value = 0;
    }
  }

  /// =========================
  /// SAVE HISTORY
  /// =========================
  void _saveToHistory() {
    final historyController = Get.find<ChatHistoryController>();
    historyController.updateSession(session, messages);
  }

  @override
  void onClose() {
    timer?.cancel();
    NotificationUtil.cancelTimerNotifications();
    super.onClose();
  }
}
