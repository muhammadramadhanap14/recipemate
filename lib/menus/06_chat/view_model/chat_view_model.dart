import 'dart:async';
import 'dart:developer' as dev;

import 'package:get/get.dart';

import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/models/model/chat_session.dart';
import 'package:recipemate/repository/chat_realtime_repository.dart';
import 'package:recipemate/services/openai_service.dart';
import 'package:recipemate/utils/notification_util.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/view_utils/app_snackbar.dart';
import 'package:vibration/vibration.dart';

import '../../../../utils/data_session_util.dart';

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
  final ChatRealtimeRepository _chatRepo = ChatRealtimeRepository();
  bool _isSessionPersisted = false;

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

    final hasUserMessage = session.messages.any((m) => m.isUser);
    if (hasUserMessage) {
      messages.assignAll(session.messages);
      _isSessionPersisted = true;
    } else {
      if (session.messages.isNotEmpty) {
        messages.assignAll(session.messages);
      } else {
        messages.add(ChatMessage(text: _initialAiGreeting, isUser: false));
      }
      _isSessionPersisted = false;
    }

    _fetchLatestMessages();
  }

  Future<void> _fetchLatestMessages() async {
    isLoading.value = true;
    try {
      final remoteMessages = await _chatRepo.loadMessages(session.id);

      if (remoteMessages.isNotEmpty) {
        messages.assignAll(remoteMessages);
        session.messages.clear();
        session.messages.addAll(remoteMessages);
        _isSessionPersisted = true;
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

    final hasConn = await RecipeMateAppUtil.checkConnection();
    if (!hasConn) {
      AppSnackbar.show(title: "Error", message: "Tidak ada koneksi internet.");
      return;
    }

    // 1. Try writing user message to Realtime Database first
    try {
      if (!_isSessionPersisted) {
        final title = text.length > 30 ? "${text.substring(0, 30)}..." : text;
        await _chatRepo.createSessionWithSpecificId(session.id, title, text);
        _isSessionPersisted = true;
      } else {
        await _chatRepo.addMessage(session.id, 'user', text);
      }
    } catch (e) {
      dev.log("ChatViewModel: Failed to save user message to DB: $e");
      AppSnackbar.show(title: "Error", message: "Gagal menyimpan pesan: $e");
      return;
    }

    // 2. If DB write succeeded, add to local messages
    messages.add(ChatMessage(text: text, isUser: true));

    // Handle Cooking Navigation via Quick Replies
    if (isCooking.value) {
      if (text == "Sudah") {
        nextStep();
        return;
      }

      if (text == "Belum") {
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
        try {
          await _chatRepo.addMessage(session.id, 'assistant', currentStepText);
        } catch (e) {
          dev.log("ChatViewModel: Failed to save assistant message: $e");
        }
        return;
      }

      final msg = "Selesaikan resep yang sedang berjalan dulu, baru bisa chat lagi.";
      messages.add(ChatMessage(text: msg, isUser: false));
      try {
        await _chatRepo.addMessage(session.id, 'assistant', msg);
      } catch (e) {
        dev.log("ChatViewModel: Failed to save assistant message: $e");
      }
      return;
    }

    isLoading.value = true;

    try {
      final response = await _openAiService.sendChatMessage(messages);

      String replyText = response.reply;
      messages.add(
        ChatMessage(
          text: replyText,
          isUser: false,
          options: response.ready ? null : (response.options != null ? _sanitizeQuickReplies(response.options!) : null),
        ),
      );

      try {
        await _chatRepo.addMessage(session.id, 'assistant', replyText);
      } catch (e) {
        dev.log("ChatViewModel: Failed to save assistant response to DB: $e");
        AppSnackbar.show(title: "Warning", message: "Pesan dibalas AI tetapi gagal disimpan ke riwayat.");
      }

      if (response.ready) {
        isReady.value = true;
      }
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      messages.add(ChatMessage(text: "Gagal mengirim pesan: $message", isUser: false));
    }

    isLoading.value = false;
  }

  /// =========================
  /// START COOKING (GENERATE RESEP VIA OPENAI)
  /// =========================
  Future<void> startCooking() async {
    final hasConn = await RecipeMateAppUtil.checkConnection();
    if (!hasConn) {
      AppSnackbar.show(title: "Error", message: "Tidak ada koneksi internet.");
      return;
    }

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

      final startMsg = "Kita mulai masak ${recipeName.value} 👨‍🍳";
      messages.add(ChatMessage(text: startMsg, isUser: false));
      if (_isSessionPersisted) await _chatRepo.addMessage(session.id, 'assistant', startMsg);

      final stepMsg = steps[0];
      messages.add(ChatMessage(text: stepMsg, isUser: false, stepIndex: 0));
      if (_isSessionPersisted) await _chatRepo.addMessage(session.id, 'assistant', stepMsg);

      final promptMsg = "Lanjut ke langkah berikutnya?";
      messages.add(ChatMessage(text: promptMsg, isUser: false, options: ["Sudah", "Belum"], stepIndex: 0));
      if (_isSessionPersisted) await _chatRepo.addMessage(session.id, 'assistant', promptMsg);
    } catch (e) {
      final message = e.toString().replaceAll('Exception: ', '');
      messages.add(ChatMessage(text: "Gagal generate resep: $message 😢", isUser: false));
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// END COOKING
  /// =========================
  void endCooking() async {
    timer?.cancel();
    isTimerRunning.value = false;
    remainingSeconds.value = 0;
    NotificationUtil.cancelTimerNotifications();

    isCooking.value = false;
    isReady.value = false;
    steps.clear();
    currentStep.value = 0;
    recipeName.value = "";

    final endMsg = "Masak selesai! 🎉 Apakah anda ingin mencoba resep lain?";
    messages.add(ChatMessage(text: endMsg, isUser: false));
    if (_isSessionPersisted) {
      await _chatRepo.addMessage(session.id, 'assistant', endMsg);
    }
  }

  /// =========================
  /// NEXT STEP
  /// =========================
  void nextStep() async {
    if (currentStep.value < steps.length - 1) {
      _clearOptionsForStep(currentStep.value);
      currentStep.value++;

      final stepText = steps[currentStep.value];
      messages.add(ChatMessage(text: stepText, isUser: false, stepIndex: currentStep.value));
      if (_isSessionPersisted) await _chatRepo.addMessage(session.id, 'assistant', stepText);

      final promptMsg = "Lanjut ke langkah berikutnya?";
      messages.add(ChatMessage(text: promptMsg, isUser: false, options: ["Sudah", "Belum"], stepIndex: currentStep.value));
      if (_isSessionPersisted) await _chatRepo.addMessage(session.id, 'assistant', promptMsg);

      updateTimerForStep(stepText);
    } else {
      endCooking();
    }
  }

  void _clearOptionsForStep(int stepIndex) {
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

  void toggleTimerFromStep(String step) async {
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

          final timeMsg = "⏰ Waktu selesai!";
          messages.add(ChatMessage(text: timeMsg, isUser: false));
          if (_isSessionPersisted) {
            await _chatRepo.addMessage(session.id, 'assistant', timeMsg);
          }
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

  @override
  void onClose() {
    timer?.cancel();
    NotificationUtil.cancelTimerNotifications();
    super.onClose();
  }
}
