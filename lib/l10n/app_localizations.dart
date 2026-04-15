import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @recipeMateAi.
  ///
  /// In en, this message translates to:
  /// **'RecipeMate AI'**
  String get recipeMateAi;

  /// No description provided for @menuErrorReport.
  ///
  /// In en, this message translates to:
  /// **'Error Report'**
  String get menuErrorReport;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @changeFoodTypes.
  ///
  /// In en, this message translates to:
  /// **'Change food types & dietary preferences'**
  String get changeFoodTypes;

  /// No description provided for @stConfirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out? All session data will be cleared, including your profile photo, fingerprint authentication, and other saved information.'**
  String get stConfirmLogout;

  /// No description provided for @stConfirmChange.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to change?'**
  String get stConfirmChange;

  /// No description provided for @stTimeOutConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout, please try again later'**
  String get stTimeOutConnection;

  /// No description provided for @stNoConnectionMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to server,\nplease check your internet connection again'**
  String get stNoConnectionMessage;

  /// No description provided for @stNotFound.
  ///
  /// In en, this message translates to:
  /// **'No Data Found'**
  String get stNotFound;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Yes, Log out'**
  String get confirmLogout;

  /// No description provided for @yesBtn.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesBtn;

  /// No description provided for @stCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get stCancelTitle;

  /// No description provided for @backBtnTitle.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backBtnTitle;

  /// No description provided for @stNextBtn.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get stNextBtn;

  /// No description provided for @stFinishBtn.
  ///
  /// In en, this message translates to:
  /// **'Finish!'**
  String get stFinishBtn;

  /// No description provided for @stRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get stRecommended;

  /// No description provided for @stTopSearching.
  ///
  /// In en, this message translates to:
  /// **'Top searching food'**
  String get stTopSearching;

  /// No description provided for @stSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get stSeeAll;

  /// No description provided for @stSearchRecipes.
  ///
  /// In en, this message translates to:
  /// **'Search recipes, ingredients...'**
  String get stSearchRecipes;

  /// No description provided for @stMorningGreeting.
  ///
  /// In en, this message translates to:
  /// **'GOOD MORNING'**
  String get stMorningGreeting;

  /// No description provided for @stDayLightGreeting.
  ///
  /// In en, this message translates to:
  /// **'GOOD AFTERNOON'**
  String get stDayLightGreeting;

  /// No description provided for @stAfternoonGreeting.
  ///
  /// In en, this message translates to:
  /// **'GOOD EVENING'**
  String get stAfternoonGreeting;

  /// No description provided for @stEveningGreeting.
  ///
  /// In en, this message translates to:
  /// **'GOOD NIGHT'**
  String get stEveningGreeting;

  /// No description provided for @stWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get stWelcomeBack;

  /// No description provided for @stWelcomeGreet.
  ///
  /// In en, this message translates to:
  /// **'Your smart kitchen assistant awaits.'**
  String get stWelcomeGreet;

  /// No description provided for @stRegister.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get stRegister;

  /// No description provided for @stRegisterGreet.
  ///
  /// In en, this message translates to:
  /// **'Start your smart cooking journey today.'**
  String get stRegisterGreet;

  /// No description provided for @stFullName.
  ///
  /// In en, this message translates to:
  /// **'FULL NAME'**
  String get stFullName;

  /// No description provided for @stShortname.
  ///
  /// In en, this message translates to:
  /// **'SHORT NAME'**
  String get stShortname;

  /// No description provided for @stAge.
  ///
  /// In en, this message translates to:
  /// **'AGE'**
  String get stAge;

  /// No description provided for @stHeight.
  ///
  /// In en, this message translates to:
  /// **'HEIGHT (CM)'**
  String get stHeight;

  /// No description provided for @stWeight.
  ///
  /// In en, this message translates to:
  /// **'WEIGHT (KG)'**
  String get stWeight;

  /// No description provided for @stEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'EMAIL ADDRESS'**
  String get stEmailAddress;

  /// No description provided for @stPassword.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get stPassword;

  /// No description provided for @stForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get stForgotPassword;

  /// No description provided for @stSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get stSignIn;

  /// No description provided for @stSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get stSignUp;

  /// No description provided for @stDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get stDontHaveAccount;

  /// No description provided for @stAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get stAlreadyHaveAccount;

  /// No description provided for @stStep1of3.
  ///
  /// In en, this message translates to:
  /// **'STEP 1 OF 3'**
  String get stStep1of3;

  /// No description provided for @stStep2of3.
  ///
  /// In en, this message translates to:
  /// **'STEP 2 OF 3'**
  String get stStep2of3;

  /// No description provided for @stStep3of3.
  ///
  /// In en, this message translates to:
  /// **'STEP 3 OF 3'**
  String get stStep3of3;

  /// No description provided for @stgreetPrefFood.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself!'**
  String get stgreetPrefFood;

  /// No description provided for @stgreetPrefFood2.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize your experience by providing some basic information'**
  String get stgreetPrefFood2;

  /// No description provided for @stgreetPrefFood3.
  ///
  /// In en, this message translates to:
  /// **'Tell us your taste!'**
  String get stgreetPrefFood3;

  /// No description provided for @stgreetPrefFood4.
  ///
  /// In en, this message translates to:
  /// **'What are your favorite food types or dietary preferences?'**
  String get stgreetPrefFood4;

  /// No description provided for @stBiometric.
  ///
  /// In en, this message translates to:
  /// **'BIOMETRIC AUTHENTICATION'**
  String get stBiometric;

  /// No description provided for @stBiometricFace.
  ///
  /// In en, this message translates to:
  /// **'Enable Face ID'**
  String get stBiometricFace;

  /// No description provided for @stBiometricFingerPrint.
  ///
  /// In en, this message translates to:
  /// **'Enable Fingerprint ID'**
  String get stBiometricFingerPrint;

  /// No description provided for @stPasswordManagement.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD MANAGEMENT'**
  String get stPasswordManagement;

  /// No description provided for @stChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get stChangePassword;

  /// No description provided for @stChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Photo'**
  String get stChangePhoto;

  /// No description provided for @stRemovPhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get stRemovPhoto;

  /// No description provided for @stChoosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose From Gallery'**
  String get stChoosePhoto;

  /// No description provided for @stTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get stTakePhoto;

  /// No description provided for @stChangeData.
  ///
  /// In en, this message translates to:
  /// **'Change Data'**
  String get stChangeData;

  /// No description provided for @stQuitApp.
  ///
  /// In en, this message translates to:
  /// **'Exit Application'**
  String get stQuitApp;

  /// No description provided for @stDoubleTapToExit.
  ///
  /// In en, this message translates to:
  /// **'Press again to exit'**
  String get stDoubleTapToExit;

  /// No description provided for @stSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get stSuccess;

  /// No description provided for @stFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get stFailed;

  /// No description provided for @stInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get stInfo;

  /// No description provided for @stError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get stError;

  /// No description provided for @stFingerprintSuccess.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint has been successfully activated'**
  String get stFingerprintSuccess;

  /// No description provided for @stFingerprintFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get stFingerprintFailed;

  /// No description provided for @stFingerprintError.
  ///
  /// In en, this message translates to:
  /// **'There is an error: '**
  String get stFingerprintError;

  /// No description provided for @stFingerprintInfo.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint is disabled'**
  String get stFingerprintInfo;

  /// No description provided for @stDontHaveBiometric.
  ///
  /// In en, this message translates to:
  /// **'Biometric is not available on this device'**
  String get stDontHaveBiometric;

  /// No description provided for @stFailedOnBoarding.
  ///
  /// In en, this message translates to:
  /// **'Failed to finish onboarding'**
  String get stFailedOnBoarding;

  /// No description provided for @stEnableFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Scan to activate Biometric feature'**
  String get stEnableFingerprint;

  /// No description provided for @stNoConnectionInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get stNoConnectionInternetTitle;

  /// No description provided for @stNoConnectionInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet settings and try again'**
  String get stNoConnectionInternetMessage;

  /// No description provided for @stRetryBtn.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get stRetryBtn;

  /// No description provided for @stReasonFailedPhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image:'**
  String get stReasonFailedPhoto;

  /// No description provided for @stNewPaswword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get stNewPaswword;

  /// No description provided for @stOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get stOldPassword;

  /// No description provided for @confirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmBtn;

  /// No description provided for @stFailedLogin.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get stFailedLogin;

  /// No description provided for @stFailedRegister.
  ///
  /// In en, this message translates to:
  /// **'Register Failed'**
  String get stFailedRegister;

  /// No description provided for @stInternalServerError.
  ///
  /// In en, this message translates to:
  /// **'Internal Server Error'**
  String get stInternalServerError;

  /// No description provided for @stNoDataFound.
  ///
  /// In en, this message translates to:
  /// **'No Data Found'**
  String get stNoDataFound;

  /// No description provided for @stNoDataFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No data available to display'**
  String get stNoDataFoundMessage;

  /// No description provided for @stNutritionalPrediction.
  ///
  /// In en, this message translates to:
  /// **'Nutritional Prediction'**
  String get stNutritionalPrediction;

  /// No description provided for @stRecipeSummary.
  ///
  /// In en, this message translates to:
  /// **'Recipe Summary'**
  String get stRecipeSummary;

  /// No description provided for @stCoreIngredients.
  ///
  /// In en, this message translates to:
  /// **'Core Ingredients'**
  String get stCoreIngredients;

  /// No description provided for @stLoginFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Scan to Login'**
  String get stLoginFingerprint;

  /// No description provided for @stLoginFingerprintErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Saved credentials not found. Please login manually once.'**
  String get stLoginFingerprintErrorMessage;

  /// No description provided for @stEnableFingerprintNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Fingerprint?'**
  String get stEnableFingerprintNowTitle;

  /// No description provided for @stEnableFingerprintNowMessage.
  ///
  /// In en, this message translates to:
  /// **'Unlock faster and more securely with your fingerprint. Would you like to enable it now?'**
  String get stEnableFingerprintNowMessage;

  /// No description provided for @stRemindMeLaterBtn.
  ///
  /// In en, this message translates to:
  /// **'Remind me later'**
  String get stRemindMeLaterBtn;

  /// No description provided for @stRemindMeLaterMessage.
  ///
  /// In en, this message translates to:
  /// **'We will remind you after 48 hours.'**
  String get stRemindMeLaterMessage;

  /// No description provided for @stInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get stInstructions;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
