import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/menus/04_home/view_model/home_view_model.dart';

import '../../../utils/view_utils/app_snackbar.dart';
import '../view/account_view.dart';
import '../view/home_view.dart';

class HomeNavViewModel extends GetxController {
  var selectedIndex = 0.obs;
  var lastPressed = Rxn<DateTime>();

  final List<Widget> _pages = [
    const HomeView(),
    const AccountView()
  ];

  Widget get currentPage => _pages[selectedIndex.value];

  void changePage(int index) {
    if (index == 0) {
      try {
        final homeVM = Get.find<HomeViewModel>();
        homeVM.searchResults.clear();
        homeVM.isSearching.value = false;
      } catch (_) {
        // Jika belum di-inject, abaikan
      }
    }
    selectedIndex.value = index;
    update();
  }

  // Double tap to exit
  Future<void> onWillPop(BuildContext context) async {
    final now = DateTime.now();
    if (lastPressed.value == null || now.difference(lastPressed.value!) > const Duration(seconds: 2)) {
      lastPressed.value = now;
      AppSnackbar.show(
        title: AppLocalizations.of(context)!.stQuitApp,
        message: AppLocalizations.of(context)!.stDoubleTapToExit
      );
      return;
    }
    // Keluar aplikasi
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

}