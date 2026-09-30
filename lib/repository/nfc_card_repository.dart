import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:prepaidcard_reader/prepaidcard_reader.dart';
import '../models/model/card_balance.dart';

class NfcCardRepository {
  final PrepaidcardReader _reader = PrepaidcardReader.instance;

  Future<void> startScan({
    required Function(CardBalance balance) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      await _reader.startSession(
        (CardModel cardModel) async {
          debugPrint("[NfcCardRepository] Card Discovered: ${cardModel.cardName}, UID: ${cardModel.cardId}, Balance Raw: ${cardModel.balance}, Number: ${cardModel.cardNumber}, Info: ${cardModel.anotherInfo}");

          final info = cardModel.anotherInfo;
          final infoLower = info.toLowerCase();

          if (infoLower.contains("error") ||
              infoLower.contains("exception") ||
              infoLower.contains("writable dex") ||
              (cardModel.cardName.isEmpty && cardModel.cardId.isEmpty && cardModel.balance.isEmpty && info.isNotEmpty)) {

            String userErrorMsg = "Gagal membaca kartu prabayar.";
            if (infoLower.contains("securityexception") || infoLower.contains("writable dex")) {
              userErrorMsg = "Sistem keamanan Android (Android 14+) memblokir pemuatan modul kartu: SecurityException (Writable dex file is not allowed).";
            } else if (info.isNotEmpty) {
              userErrorMsg = info;
            }

            onError(userErrorMsg);
            unawaited(stopSession());
            return;
          }

          int parsedBalance = 0;
          final digitsOnly = cardModel.balance.replaceAll(RegExp(r'[^0-9]'), '');
          if (digitsOnly.isNotEmpty) {
            parsedBalance = int.tryParse(digitsOnly) ?? 0;
          }

          String? displayCardNumber;
          if (cardModel.cardNumber.isNotEmpty) {
            displayCardNumber = cardModel.cardNumber;
          } else if (cardModel.anotherInfo.isNotEmpty) {
            displayCardNumber = cardModel.anotherInfo;
          }

          final cardBalance = CardBalance(
            uid: cardModel.cardId.isNotEmpty ? cardModel.cardId : '-',
            saldo: parsedBalance,
            lastReadTime: DateTime.now(),
            cardType: cardModel.cardName.isNotEmpty ? cardModel.cardName : 'Kartu Prabayar',
            cardNumber: displayCardNumber,
            anotherInfo: cardModel.anotherInfo.isNotEmpty ? cardModel.anotherInfo : null,
          );

          onSuccess(cardBalance);
          unawaited(stopSession());
        },
        stopOnDiscovered: false,
        onError: (NfcError error) async {
          onError('Gagal membaca kartu: ${error.message}');
          unawaited(stopSession());
        },
      );
    } on PlatformException catch (e) {
      onError('Gagal memulai sesi NFC: ${e.message ?? e.code}');
      unawaited(stopSession());
    } catch (e) {
      onError('Gagal memulai sesi NFC: $e');
      unawaited(stopSession());
    }
  }

  Future<void> stopSession() async {
    try {
      await _reader.stopSession();
    } catch (_) {}
  }
}