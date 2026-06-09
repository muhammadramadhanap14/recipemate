import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/model_response/detail_recipe_response.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/constant_var.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/app_snackbar.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class HomeDetailViewModel extends GetxController {
  final ApiRepository apiRepository;
  final int recipeId;
  final Rx<DetailRecipeResponse?> recipeDetail = Rx<DetailRecipeResponse?>(null);
  final RxBool isLoading = false.obs;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isDialogShowing = false;

  HomeDetailViewModel({
    required this.apiRepository,
    required this.recipeId,
  });

  @override
  void onInit() {
    super.onInit();
    getRecipeDetail();
    _startConnectivityListener();
    checkInitialConnection();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
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

  Future<void> getRecipeDetail() async {
    isLoading.value = true;
    try {
      final response = await apiRepository.getRecipeInformation(recipeId);
      if (response != null) {
        recipeDetail.value = DetailRecipeResponse.fromJson(response);
      }
    } catch (e) {
      AppSnackbar.show(
        title: "Error",
        message: "Failed to fetch recipe detail: $e",
      );
    } finally {
      isLoading.value = false;
    }
  }
}