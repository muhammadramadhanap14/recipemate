import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/constant_var.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/model_response/search_recipes_response.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/view_utils/view_dialog_util.dart';
import '../../../utils/view_utils/app_snackbar.dart';

class HomeViewModel extends GetxController {
  final ApiRepository apiRepository;
  final DataSessionUtilController session;
  final RxString userName = ''.obs;
  final RxList<Results> searchResults = <Results>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isFingerprintEnabled = false.obs;
  final RxList<dynamic> autoCompleteResults = <dynamic>[].obs;
  final RxBool isAutoCompleteLoading = false.obs;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isDialogShowing = false;

  HomeViewModel({
    required this.apiRepository,
    required this.session,
  });

  @override
  void onInit() {
    super.onInit();
    getUserName();
    _startConnectivityListener();
    checkInitialConnection();
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) {
        autoCompleteResults.clear();
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      checkAndShowFingerprintReminder();
    });
  }

  void _startConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      checkInitialConnection();
    });
  }

  Future<void> checkInitialConnection() async {
    final hasConnection = await RecipeMateAppUtil.checkConnection();
    if (!hasConnection) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (_isDialogShowing) return;

    final context = Get.context;
    if (context != null) {
      _isDialogShowing = true;
      ViewDialogUtil().showOneButtonActionDialog(
        AppLocalizations.of(context)!.stNoConnectionMessage,
        AppLocalizations.of(context)!.backBtnTitle,
        ConstantVar.noConnectionGif,
        context,
        null,
            (dynamic val) {
          _isDialogShowing = false;
          checkInitialConnection();
        },
      );
    }
  }

  void resetSearch() {
    searchController.clear();
    searchResults.clear();
    autoCompleteResults.clear();
    isSearching.value = false;
    isAutoCompleteLoading.value = false;
    searchFocusNode.unfocus();
  }

  Future<void> getUserName() async {
    await session.loadFullName();
    userName.value = session.stFullName.value;
  }

  Future<void> getAutoComplete(String query) async {
    if (query.trim().isEmpty) {
      autoCompleteResults.clear();
      return;
    }
    isAutoCompleteLoading.value = true;
    try {
      final response = await apiRepository.getRecipeAutocomplete(query: query);
      if (response != null) {
        autoCompleteResults.assignAll(response);
      }
    } catch (e) {
      debugPrint("Autocomplete error: $e");
    } finally {
      isAutoCompleteLoading.value = false;
    }
  }

  Future<void> searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      autoCompleteResults.clear();
      return;
    }
    autoCompleteResults.clear();
    searchFocusNode.unfocus();
    isSearching.value = true;
    try {
      final response = await apiRepository.getRecipesComplexSearch(query: query);
      if (response != null) {
        final searchResponse = SearchRecipesResponse.fromJson(response);
        searchResults.assignAll(searchResponse.results ?? []);
      }
    } catch (e) {
      AppSnackbar.show(
        title: "Error",
        message: "Failed to fetch recipes: $e",
      );
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
    searchController.dispose();
    searchFocusNode.dispose();
    searchResults.clear();
    autoCompleteResults.clear();
    isSearching.value = false;
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}