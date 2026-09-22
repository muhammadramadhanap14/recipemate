import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/utils/dimens_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    RecipeMateAppUtil.init(context);
    final LoginViewModel viewModel = Get.put(
      LoginViewModel(
        apiRepository: Get.find<ApiRepository>(),
        sessionController: Get.find<DataSessionUtilController>(),
        context: context,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    final double screenW = RecipeMateAppUtil.screenWidth;
    final double screenH = RecipeMateAppUtil.screenHeight;
    final double logoSize = screenW * 0.42;

    return GlassScaffold(
      edgeToEdge: true,
      extendBody: true,
      edgeFade: false,
      background: Stack(
        children: [
          Container(color: Theme.of(context).scaffoldBackgroundColor),
          Positioned(
            top: -50,
            right: -50,
            child: buildBlurBlob(
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.30),
              350,
            ),
          ),
          Positioned(
            bottom: 200,
            left: -100,
            child: buildBlurBlob(
              Colors.deepPurple.withValues(alpha: 0.25),
              400,
            ),
          ),
          Positioned(
            top: 250,
            left: -50,
            child: buildBlurBlob(
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.20),
              250,
            ),
          ),
        ],
      ),
      body: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenW * 0.08,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenH * 0.06),

                          Image.asset(
                            "assets/images/ic_logo_recipemate.png",
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: screenH * 0.03),

                          customText(
                            text: AppLocalizations.of(context)!.stWelcomeBack,
                            fontSize: DimensText.superHeaderText(context) * 1.1,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'times_new_roman_med_italic',
                            color: Theme.of(context).colorScheme.onSurface,
                            textAlign: TextAlign.center,
                            intMaxLine: null,
                          ),

                          SizedBox(height: screenH * 0.008),

                          customText(
                            text: "Your smart kitchen assistant awaits.",
                            fontSize: DimensText.captionText(context),
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: screenH * 0.09),

                          GlassButton.custom(
                            onTap: viewModel.onGoogleLoginPressed,
                            enabled: true,
                            width: double.infinity,
                            height: screenH * 0.068,
                            shape: LiquidRoundedRectangle(borderRadius: screenW * 0.06),
                            style: GlassButtonStyle.filled,
                            useOwnLayer: true,
                            settings: LiquidGlassSettings(
                              glassColor: Theme.of(context).cardColor,
                              thickness: 10,
                              blur: 8,
                              chromaticAberration: 0.4,
                              lightIntensity: 1.2,
                              refractiveIndex: 1.68,
                              saturation: 1.1,
                              ambientStrength: 1.1,
                              ambientRim: 0.3,
                              edgeAbsorption: 0.12,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/google_logo.png",
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: screenW * 0.03),
                                  customText(
                                    text: "Sign in with Google",
                                    fontSize: DimensText.buttonSmallText(context),
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: screenH * 0.02),

                          customText(
                            text: "By signing in, you agree to our Terms of Service and Privacy Policy.",
                            fontSize: DimensText.microText(context),
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                            textAlign: TextAlign.center,
                            intMaxLine: null,
                          ),

                          const Spacer(),

                          Padding(
                            padding: EdgeInsets.only(
                              top: screenH * 0.02,
                              bottom: screenH * 0.04,
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: '${AppLocalizations.of(context)!.stDontHaveAccount} ',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontSize: DimensText.captionText(context),
                                ),
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!.stSignUp,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.offNamed('/register');
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}