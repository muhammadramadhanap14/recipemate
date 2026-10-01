import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/models/favorite_recipe.dart';
import 'package:recipemate/repository/favorites_realtime_repository.dart';
import 'package:recipemate/utils/view_utils/app_snackbar.dart';
import 'package:vibration/vibration.dart';

class FavoritesController extends GetxController {
  final FavoritesRealtimeRepository _repo = FavoritesRealtimeRepository();
  
  var favorites = <FavoriteRecipe>[].obs;
  var favoriteIds = <int>{}.obs;
  var isLoading = false.obs;
  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    _initListener();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _sub?.cancel();
      if (user != null) {
        _initListener();
      } else {
        favorites.clear();
        favoriteIds.clear();
      }
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void _initListener() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final isEmailUser = user.providerData.any((p) => p.providerId == 'password');
      if (isEmailUser && !user.emailVerified) return;

      isLoading.value = true;
      _sub = _repo.watchFavorites().listen((list) {
        favorites.assignAll(list);
        favoriteIds.assignAll(list.map((e) => e.id));
        isLoading.value = false;
      }, onError: (_) {
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      debugPrint("FavoritesController error: $e");
    }
  }

  bool isFavorite(int recipeId) {
    return favoriteIds.contains(recipeId);
  }

  Future<void> toggleFavorite(FavoriteRecipe recipe) async {
    final user = FirebaseAuth.instance.currentUser;
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context) : null;

    if (user == null) {
      if (l10n != null) {
        AppSnackbar.show(title: l10n.stError, message: "Silakan masuk untuk menyimpan favorit.");
      }
      return;
    }

    final isFav = isFavorite(recipe.id);

    // Optimistic update
    if (isFav) {
      favoriteIds.remove(recipe.id);
      favorites.removeWhere((e) => e.id == recipe.id);
    } else {
      if (favorites.length >= 500) {
        if (l10n != null) {
          AppSnackbar.show(title: l10n.stError, message: "Batas maksimal 500 resep favorit tercapai.");
        }
        return;
      }
      favoriteIds.add(recipe.id);
      favorites.insert(0, recipe);
    }

    // Haptic feedback
    try {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 50);
      }
    } catch (_) {}

    try {
      if (isFav) {
        await _repo.remove(recipe.id);
      } else {
        await _repo.add(recipe);
      }
    } catch (e) {
      // Rollback on error
      if (isFav) {
        favoriteIds.add(recipe.id);
        favorites.insert(0, recipe);
      } else {
        favoriteIds.remove(recipe.id);
        favorites.removeWhere((e) => e.id == recipe.id);
      }
      if (l10n != null) {
        AppSnackbar.show(title: l10n.stError, message: "Gagal memperbarui favorit: $e");
      }
    }
  }
}
