import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import '../../../models/model/card_balance.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../repository/nfc_card_repository.dart';
import '../view/nfc_result_view.dart';

class NfcController extends GetxController {
  final NfcCardRepository _service = NfcCardRepository();

  final Rx<CardBalance?> cardBalance = Rx<CardBalance?>(null);
  final RxList<CardTransaction> transactions = <CardTransaction>[].obs;
  final RxBool isScanning = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  String get cardholderName {
    if (Get.isRegistered<DataSessionUtilController>()) {
      final session = Get.find<DataSessionUtilController>();
      if (session.stFullName.value.isNotEmpty) {
        return session.stFullName.value;
      }
    }
    return "Alex Culinary";
  }

  String get maskedCardNumber {
    final balance = cardBalance.value;
    if (balance == null) return "••••  ••••  ••••  4092";

    String digits = "";
    if (balance.cardNumber != null && balance.cardNumber!.isNotEmpty) {
      digits = balance.cardNumber!.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
    } else if (balance.uid.isNotEmpty) {
      digits = balance.uid.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
    }

    if (digits.length >= 4) {
      final last4 = digits.substring(digits.length - 4).toUpperCase();
      return "••••  ••••  ••••  $last4";
    }

    return "••••  ••••  ••••  4092";
  }

  @override
  void onClose() {
    _service.stopSession();
    super.onClose();
  }

  void resetState() {
    _service.stopSession();
    cardBalance.value = null;
    transactions.clear();
    errorMessage.value = null;
    isScanning.value = false;
  }

  void scanCard() {
    if (isScanning.value) return;

    resetState();
    isScanning.value = true;
    debugPrint("[NfcController] Starting scanCard...");

    _service.startScan(
      onSuccess: (CardBalance balance) {
        debugPrint("[NfcController] onSuccess -> Saldo: ${balance.saldo}, Type: ${balance.cardType}, CardNumber: ${balance.cardNumber}");

        cardBalance.value = balance;
        errorMessage.value = null;
        isScanning.value = false;

        try {
          Vibration.hasVibrator().then((hasVib) {
            if (hasVib == true) Vibration.vibrate(duration: 100);
          });
        } catch (e) {
          debugPrint("[NfcController] Vibration error ignored: $e");
        }

        Get.to(() => const NfcResultView());
      },
      onError: (String error) {
        debugPrint("[NfcController] onError -> $error");

        errorMessage.value = error;
        cardBalance.value = null;
        transactions.clear();
        isScanning.value = false;
      },
    );
  }
}