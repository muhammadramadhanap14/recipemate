import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/constant_var.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/model/user_tracking.dart';
import '../../../models/model_response/search_recipes_response.dart';
import '../../../repository/api_repository.dart';
import '../../../repository/tracking_repository.dart';
import '../../../services/tracking_service.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/location_util.dart';
import '../../../utils/notification_util.dart';
import '../../../utils/view_utils/view_dialog_util.dart';
import '../../../utils/view_utils/app_snackbar.dart';

class HomeViewModel extends GetxController {
  final ApiRepository apiRepository;
  final DataSessionUtilController session;
  final TrackingRepository _trackingRepository = TrackingRepository();
  late final TrackingEngine _engine = TrackingEngineFactory.create();

  final RxString userName = ''.obs;
  final RxList<Results> searchResults = <Results>[].obs;
  final RxList<dynamic> recommendedRecipes = <dynamic>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoadingRecommended = false.obs;
  final RxBool isFingerprintEnabled = false.obs;
  final RxList<dynamic> autoCompleteResults = <dynamic>[].obs;
  final RxBool isAutoCompleteLoading = false.obs;
  final RxString searchText = ''.obs;
  final RxList<dynamic> foodArticles = <dynamic>[].obs;
  final RxBool isLoadingArticles = false.obs;

  // Tracking state
  final RxBool isTrackingActive = false.obs;
  int? activeIdTracking;

  final List<String> articleKeywords = [
    'cooking',
    'healthy',
    'nutrition',
    'food',
    'restaurant',
    'recipe',
    'diet',
    'organic',
    'vegan',
    'gourmet',
  ];

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isDialogShowing = false;

  HomeViewModel({required this.apiRepository, required this.session});

  @override
  void onInit() {
    super.onInit();
    getUserName();
    checkActiveSession();
    _startConnectivityListener();
    checkInitialConnection();
    getRecommendedRecipes();
    getDynamicFoodArticles();
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) {
        autoCompleteResults.clear();
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      checkAndShowFingerprintReminder();
    });
  }

  Future<void> checkActiveSession() async {
    final nik = session.stUserId.value.isNotEmpty ? session.stUserId.value : 'default_user';
    final now = DateTime.now();
    final todayStr = DateFormat(ConstantVar.stYearLineFormat).format(now);
    final active = await _trackingRepository.getActiveTracking(nik, todayStr);
    if (active != null) {
      isTrackingActive.value = true;
      activeIdTracking = active.idTrc;
    } else {
      isTrackingActive.value = false;
      activeIdTracking = null;
    }
  }

  Future<void> handleStartTracking(BuildContext context) async {
    final gpsActive = await LocationUtil.isGPsActive();
    if (!gpsActive) {
      await LocationUtil.openLocationSettings();
      return;
    }

    final position = await LocationUtil.getCurrentPosition(10);
    if (position == null || (position.latitude == 0.0 && position.longitude == 0.0)) {
      AppSnackbar.show(
        title: "Info",
        message: "Sedang mendapatkan lokasi, silakan coba lagi...",
      );
      return;
    }

    final now = DateTime.now();
    final displayFormat = DateFormat("dd MMM yyyy, HH:mm");
    final formattedTime = displayFormat.format(now);

    await ViewDialogUtil.showTrackingBottomSheet(
      context,
      icon: const Icon(Icons.radar_rounded, color: Color(0xFF5B8C3E), size: 28),
      title: "Mulai Pelacakan",
      message: TextSpan(
        children: [
          const TextSpan(text: "Aktifkan Pelacakan untuk mencatat aktivitasmu saat melakukan checking di lapangan, dimulai saat "),
          TextSpan(
            text: formattedTime,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: "."),
        ],
      ),
      positiveText: "Mulai",
      negativeText: "Batal",
      onPositiveClick: () async {
        var permission = await LocationUtil.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await LocationUtil.requestPermission();
        }
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          if (permission == LocationPermission.deniedForever) {
            await LocationUtil.openAppSettings();
          }
          return;
        }

        final nik = session.stUserId.value.isNotEmpty ? session.stUserId.value : 'default_user';
        final formatter = DateFormat(ConstantVar.stYearDateTimeLineFormat);
        final dateStr = formatter.format(now);

        final trackingModel = UserTracking(
          idTrc: 0,
          nik: nik,
          createDate: dateStr,
          startDate: dateStr,
          startLat: position.latitude,
          startLng: position.longitude,
          trackingStatus: 0,
        );

        final idTrc = await _trackingRepository.insertUserTracking(trackingModel);

        if (idTrc > 0) {
          activeIdTracking = idTrc;
          await Future.delayed(const Duration(milliseconds: 500));

          await _engine.start(
            nik: nik,
            idTracking: idTrc,
            startLat: position.latitude,
            startLng: position.longitude,
          );

          isTrackingActive.value = true;
          AppSnackbar.show(title: "Sukses", message: "Pelacakan dimulai.");
        }
      },
    );
  }

  Future<void> handleStopTracking(BuildContext context) async {
    final gpsActive = await LocationUtil.isGPsActive();
    if (!gpsActive) {
      await LocationUtil.openLocationSettings();
      return;
    }

    final position = await LocationUtil.getCurrentPosition(10);
    if (position == null || (position.latitude == 0.0 && position.longitude == 0.0)) {
      AppSnackbar.show(
        title: "Info",
        message: "Sedang mendapatkan lokasi, silakan coba lagi...",
      );
      return;
    }

    final now = DateTime.now();
    final displayFormat = DateFormat("dd MMM yyyy, HH:mm");
    final formattedTime = displayFormat.format(now);

    await ViewDialogUtil.showTrackingBottomSheet(
      context,
      icon: const Icon(Icons.stop_rounded, color: Colors.red, size: 28),
      title: "Akhiri Pelacakan",
      message: TextSpan(
        children: [
          const TextSpan(text: "Kamu akan mengakhiri sesi pelacakan saat "),
          TextSpan(
            text: formattedTime,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ". Pastikan semua aktivitas checking/inspeksi sudah selesai."),
        ],
      ),
      positiveText: "Selesai",
      negativeText: "Batal",
      onPositiveClick: () async {
        final formatter = DateFormat(ConstantVar.stYearDateTimeLineFormat);
        final endDateStr = formatter.format(now);

        if (activeIdTracking != null) {
          await _trackingRepository.updateFinishTracking(
            activeIdTracking!,
            position.latitude,
            position.longitude,
            endDateStr,
          );
        }

        await _engine.stop();
        await NotificationUtil.showTrackingStoppedNotification();

        isTrackingActive.value = false;
        activeIdTracking = null;
        AppSnackbar.show(title: "Sukses", message: "Pelacakan diakhiri.");
      },
    );
  }

  void _startConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
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
    searchText.value = '';
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
      final response = await apiRepository.getRecipesComplexSearch(
        query: query,
      );
      if (response != null) {
        final searchResponse = SearchRecipesResponse.fromJson(response);
        searchResults.assignAll(searchResponse.results ?? []);
      }
    } catch (e) {
      AppSnackbar.show(title: "Error", message: "Failed to fetch recipes: $e");
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> launchBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      AppSnackbar.show(title: "Error", message: "Could not launch $url");
    }
  }

  Future<void> getDynamicFoodArticles() async {
    isLoadingArticles.value = true;
    try {
      final articleKeywords = [
        'gourmet',
        'culinary',
        'recipe',
        'cooking',
        'healthy food',
        'nutrition',
        'restaurant',
        'street food',
        'dessert',
        'main course',
      ];
      final sortOptions = ['relevancy', 'popularity', 'publishedAt'];

      final randomKeyword = (articleKeywords..shuffle()).first;
      final randomSort = (sortOptions..shuffle()).first;

      final query = 'food AND $randomKeyword';
      debugPrint("Query nya adalah: $query");

      final response = await apiRepository.getFoodNews(
        query: query,
        sortBy: randomSort,
      );

      if (response != null && response['status'] == 'ok' && response['articles'] != null) {
        final List<dynamic> rawArticles = response['articles'];
        if (rawArticles.isNotEmpty) {
          final mappedArticles =
            rawArticles.where((art) => art['title'] != '[Removed]' && art['urlToImage'] != null).map(
              (art) => {
                'title': art['title'] ?? 'No Title',
                'image': art['urlToImage'] ?? '',
                'link': art['url'] ?? '',
              },
            ).toList();
          if (mappedArticles.isNotEmpty) {
            foodArticles.assignAll(mappedArticles);
            return;
          }
        }
      }

      _setFallbackArticles();
    } catch (e) {
      debugPrint("Error fetching dynamic food articles: $e");
      _setFallbackArticles();
    } finally {
      isLoadingArticles.value = false;
    }
  }

  void _setFallbackArticles() {
    foodArticles.assignAll([
      {
        'title': '10 Healthy Breakfast Ideas for a Productive Day',
        'image': 'https://images.unsplash.com/photo-1494390248081-4e521a5940db?q=80&w=1000&auto=format&fit=crop',
        'link': 'https://www.healthline.com/nutrition/healthy-breakfast-ideas',
      },
      {
        'title': 'Mastering Italian Cuisine: The Basics You Need to Know',
        'image': 'https://images.unsplash.com/photo-1498579150354-977475b7ea0b?q=80&w=1000&auto=format&fit=crop',
        'link': 'https://www.bonappetit.com/test-kitchen/how-to/article/italian-cooking-basics',
      },
      {
        'title': 'The Secret to Perfect Sushi Rice Every Single Time',
        'image': 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=1000&auto=format&fit=crop',
        'link': 'https://www.japancentre.com/en/recipes/10-how-to-make-perfect-sushi-rice',
      },
    ]);
  }

  Future<void> getRecommendedRecipes() async {
    isLoadingRecommended.value = true;
    try {
      final response = await apiRepository.getRandomRecipes(number: 2);
      if (response != null && response['recipes'] != null) {
        recommendedRecipes.assignAll(response['recipes'] ?? []);
      }
    } catch (e) {
      debugPrint("Error fetching recommended recipes: $e");
    } finally {
      isLoadingRecommended.value = false;
    }
  }

  Future<void> checkAndShowFingerprintReminder() async {
    await session.loadFingerprint();
    if (session.isFingerprintEnabled.value) return;
    final lastReminder = await session.dataSessionUtil
        .getLastFingerprintReminder();
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
        session.dataSessionUtil.setLastFingerprintReminder(
          DateTime.now().millisecondsSinceEpoch,
        );
        Get.toNamed('/security');
      },
      onNegativeClick: () {
        session.dataSessionUtil.setLastFingerprintReminder(
          DateTime.now().millisecondsSinceEpoch,
        );
        Navigator.of(context).pop();
        AppSnackbar.show(
          title: l10n.stInfo,
          message: l10n.stRemindMeLaterMessage,
        );
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    searchResults.clear();
    recommendedRecipes.clear();
    autoCompleteResults.clear();
    isSearching.value = false;
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}
