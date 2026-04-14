import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/menus/03_register/view/register_view.dart';
import 'package:recipemate/menus/04_home/view/home_detail_view.dart';
import 'package:recipemate/menus/06_security/view/security_view.dart';
import 'package:recipemate/repository/api_repository.dart';
import 'package:recipemate/utils/connection_util.dart';
import 'package:recipemate/utils/data_session_util.dart';
import 'package:recipemate/utils/data_session_util_controller.dart';
import 'package:recipemate/utils/view_utils/error_view.dart';
import 'package:recipemate/utils/view_utils/theme_controller.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'menus/01_splash/view/splash_view.dart';
import 'menus/02_login/view/login_view.dart';
import 'menus/04_home/view/home_nav_view.dart';
import 'menus/05_recipemate_ai/view/recipemate_ai_view.dart';
import 'utils/view_utils/app_theme.dart';

final talker = TalkerFlutter.init(); // Initialize Talker instance here
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Locale? appLocale;

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    //Inisialisasi awal storage untuk ambil Tema & Bahasa
    final sessionUtil = DataSessionUtil();
    final initialTheme = await sessionUtil.getLastTheme();
    final initialLang = await sessionUtil.getLastLanguage();

    //register dependency injection
    Get.put<ApiRepository>(ApiRepository(), permanent: true);
    Get.put<ConnectionUtil>(ConnectionUtil(), permanent: true);
    
    // Inisialisasi ThemeController dengan tema tersimpan
    final themeController = Get.put<ThemeController>(ThemeController(), permanent: true);
    themeController.initTheme(initialTheme);
    
    Get.put<DataSessionUtil>(DataSessionUtil(), permanent: true);

    Get.put<DataSessionUtilController>(
      DataSessionUtilController(dataSessionUtil: Get.find()),
      permanent: true,
    );

    //Set Locale awal jika ada
    if (initialLang != null && initialLang.isNotEmpty) {
      appLocale = Locale(initialLang);
    }

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

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() {
      return GetMaterialApp(
        title: 'Recipe Mate',
        //uncomment untuk aktifkan flutter talker
        // navigatorObservers: [TalkerRouteObserver(talker)], // Correct way to pass talker instance
        // navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
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
        locale: appLocale,
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
          GetPage(name: '/recipemate_ai', page: () => const RecipemateAiView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
          GetPage(name: '/security', page: () => const SecurityView(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 600)),
        ],
      );
    });
  }
}