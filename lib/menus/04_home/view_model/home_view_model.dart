import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/utils/view_utils/app_snackbar.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/model_response/search_recipes_response.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class HomeViewModel extends GetxController {
  final ApiRepository apiRepository;
  final DataSessionUtilController session;
  final RxString userName = ''.obs;
  final RxList<Results> searchResults = <Results>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isFingerprintEnabled = false.obs;

  HomeViewModel({
    required this.apiRepository,
    required this.session,
  });

  @override
  void onInit() {
    super.onInit();
    getUserName();
    Future.delayed(const Duration(seconds: 1), () {
      checkAndShowFingerprintReminder();
    });
  }

  Future<void> getUserName() async {
    await session.loadFullName();
    userName.value = session.stFullName.value;
  }

  Future<void> searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }
    isSearching.value = true;
    try {
      final response = await apiRepository.getRecipesComplexSearch(query: query);
      if (response != null) {
        final searchResponse = SearchRecipesResponse.fromJson(response);
        searchResults.assignAll(searchResponse.results ?? []);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch recipes: $e");
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> checkAndShowFingerprintReminder() async {
    await session.loadFingerprint();
    if (session.isFingerprintEnabled.value) return;
    final lastReminder = await session.dataSessionUtil.getLastFingerprintReminder();
    final now = DateTime.now().millisecondsSinceEpoch;
    if (lastReminder == null) {
      openEnabledFingerprintDialog(Get.context!);
    } else {
      final differenceInHours = (now - lastReminder) / (1000 * 60 * 60);
      if (differenceInHours >= 48) {
        openEnabledFingerprintDialog(Get.context!);
      }
    }
  }

  void openEnabledFingerprintDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ViewDialogUtil().showConfirmDialog(
      title: l10n.stEnableFingerprintNowTitle,
      icon: Icons.fingerprint,
      context: context,
      message: l10n.stEnableFingerprintNowMessage,
      positiveTitle: l10n.yesBtn,
      negativeTitle: l10n.stRemindMeLaterBtn,
      onPositiveClick: () {
        session.dataSessionUtil.setLastFingerprintReminder(DateTime.now().millisecondsSinceEpoch);
        Get.toNamed('/security');
      },
      onNegativeClick: () {
        session.dataSessionUtil.setLastFingerprintReminder(DateTime.now().millisecondsSinceEpoch);
        Navigator.of(context).pop();
        AppSnackbar.show(
          title: l10n.stInfo,
          message: l10n.stRemindMeLaterMessage
        );
      },
    );
  }

  @override
  void onClose() {
    searchResults.clear();
    isSearching.value = false;
    super.onClose();
  }
}