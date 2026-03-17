import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/menus/03_register/view/register_view.dart';
import 'package:recipemate/menus/04_home/view/home_detail_view.dart';
import 'package:recipemate/menus/05_preference_food/view/preference_food_dua_view.dart';
import 'package:recipemate/menus/05_preference_food/view/preference_food_satu_view.dart';
import 'package:recipemate/menus/05_preference_food/view/preference_food_tiga_view.dart';
import 'package:recipemate/menus/06_recipemate_ai/view/recipemate_ai_view.dart';
import 'package:recipemate/menus/07_settings/view/settings_view.dart';
import 'package:recipemate/repository/api_repository.dart';
import 'package:recipemate/utils/connection_util.dart';
import 'package:recipemate/utils/view_utils/error_view.dart';
import 'package:recipemate/utils/view_utils/theme_controller.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'menus/01_splash/view/splash_view.dart';
import 'menus/02_login/view/login_view.dart';
import 'menus/04_home/view/home_nav_view.dart';
import 'utils/view_utils/app_theme.dart';

final talker = TalkerFlutter.init(); // Initialize Talker instance here
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Locale? appLocale;

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    //register dependency injection
    Get.put<ApiRepository>(ApiRepository(), permanent: true);
    Get.put<ConnectionUtil>(ConnectionUtil(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);

    // Set Flutter's error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      talker.handle(details.exception, details.stack);
      // String firstStackLine = details.stack.toString().split('\n').first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushReplacementNamed(
          '/error',
          arguments: '${details.exception}\n${details.stack.toString()}',
        );
      });
    };

    runApp(const RecipemateApp());
  }, (error, stackTrace) {
    talker.handle(error, stackTrace);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.pushReplacementNamed(
        '/error',
        arguments: '$error\n$stackTrace',
      );
    });
  });
}

class RecipemateApp extends StatelessWidget {
  const RecipemateApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() {
      return GetMaterialApp(
        title: 'Recipe Mate',
        //uncomment untuk aktifkan flutter talker
        // navigatorObservers: [TalkerRouteObserver(talker)], // Correct way to pass talker instance
        // navigatorKey: navigatorKey,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('id'),
        ],
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,
        initialRoute: '/',
        getPages: [
          //GOTO FORM
          GetPage(name: '/', page: () => const SplashView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
          GetPage(name: '/error', page: () => ErrorView(errorMessage: Get.arguments as String), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
          GetPage(name: '/login', page: () => const LoginView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
          GetPage(name: '/register', page: () => const RegisterView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
          GetPage(name: '/home', page: () => const HomeNavView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
          GetPage(name: '/home_detail', page: () => const HomeDetailView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
          GetPage(name: '/preference_food_satu', page: () => PreferenceFoodSatuView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
          GetPage(name: '/preference_food_dua', page: () => PreferenceFoodDuaView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
          GetPage(name: '/preference_food_tiga', page: () => PreferenceFoodTigaView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
          GetPage(name: '/recipemate_ai', page: () => const RecipemateAiView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
          GetPage(name: '/settings', page: () => const SettingsView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
        ],
      );
    });
  }
}