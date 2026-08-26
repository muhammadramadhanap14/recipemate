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
    final double logoSize = screenW * 0.45;

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
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              350,
            ),
          ),
          Positioned(
            bottom: 200,
            left: -100,
            child: buildBlurBlob(
              Colors.deepPurple.withValues(alpha: 0.1),
              400,
            ),
          ),
          Positioned(
            top: 250,
            left: -50,
            child: buildBlurBlob(
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
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
                        SizedBox(height: screenH * 0.03),

                        Image.asset(
                          "assets/images/ic_logo_recipemate.png",
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.contain,
                        ),

                        SizedBox(height: screenH * 0.02),

                        customText(
                          text: AppLocalizations.of(context)!.stWelcomeBack,
                          fontSize: DimensText.superHeaderText(context),
                          fontWeight: FontWeight.w800,
                          fontFamily: 'times_new_roman_med_italic',
                          color: Theme.of(context).colorScheme.onSurface,
                          textAlign: TextAlign.center,
                          intMaxLine: null
                        ),

                        customText(
                          text: AppLocalizations.of(context)!.stWelcomeGreet,
                          fontSize: DimensText.captionText(context),
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: screenH * 0.05),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: customText(
                            text: AppLocalizations.of(context)!.stEmailAddress,
                            fontSize: DimensText.microText(context),
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),

                        SizedBox(height: screenH * 0.01),

                        GlassTextField(
                          height: RecipeMateAppUtil.screenHeight * 0.065,
                          focusNode: viewModel.emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: viewModel.setEmail,
                          placeholder: "alex@example.com",
                          textStyle: TextStyle(
                            fontSize: DimensText.captionText(context),
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          placeholderStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: DimensText.captionText(context),
                            fontFamily: 'Poppins-Regular',
                          ),
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: screenW * 0.06,
                          ),
                          settings: const LiquidGlassSettings(
                            glassColor: Colors.transparent,
                            thickness: 60,
                            blur: 3,
                            chromaticAberration: 0.3,
                            lightIntensity: 0.6,
                            refractiveIndex: 1.59,
                            saturation: 1.0,
                            ambientStrength: 1,
                          ),
                        ),

                        SizedBox(height: screenH * 0.022),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              text: AppLocalizations.of(context)!.stPassword,
                              fontSize: DimensText.microText(context),
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            customText(
                              text: AppLocalizations.of(context)!.stForgotPassword,
                              fontSize: DimensText.microText(context),
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ],
                        ),

                        SizedBox(height: screenH * 0.01),

                        Obx(() => GlassTextField(
                          height: RecipeMateAppUtil.screenHeight * 0.065,
                          focusNode: viewModel.passwordFocusNode,
                          obscureText: viewModel.isObscureText.value,
                          onChanged: viewModel.setPassword,
                          placeholder: "••••••••",
                          textStyle: TextStyle(
                            fontSize: DimensText.captionText(context),
                            color: Theme.of(context).colorScheme.onSurface,
                            fontFamily: 'Poppins-Regular',
                          ),
                          placeholderStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: DimensText.captionText(context),
                            fontFamily: 'Poppins-Regular',
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).colorScheme.primary,
                            size: screenW * 0.06,
                          ),
                          suffixIcon: Icon(
                            viewModel.isObscureText.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onSuffixTap: viewModel.togglePasswordVisibility,
                          settings: const LiquidGlassSettings(
                            glassColor: Colors.transparent,
                            thickness: 60,
                            blur: 3,
                            chromaticAberration: 0.3,
                            lightIntensity: 0.6,
                            refractiveIndex: 1.59,
                            saturation: 1.0,
                            ambientStrength: 1,
                          ),
                        )),

                        SizedBox(height: screenH * 0.025),

                        Obx(() => Row(
                          children: [
                            Expanded(
                              child: GlassButton.custom(
                                onTap: viewModel.onLoginPressed,
                                enabled: viewModel.isValidButton.value,
                                width: double.infinity,
                                height: screenH * 0.065,
                                shape: LiquidRoundedRectangle(borderRadius: screenW * 0.04),
                                style: GlassButtonStyle.prominent,
                                useOwnLayer: true,
                                settings: LiquidGlassSettings(
                                  glassColor: viewModel.isValidButton.value
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                                  thickness: 60,
                                  blur: 3,
                                  chromaticAberration: 0.3,
                                  lightIntensity: 0.6,
                                  refractiveIndex: 1.59,
                                  saturation: 1.0,
                                  ambientStrength: 1,
                                ),
                                child: Center(
                                  child: customText(
                                    text: AppLocalizations.of(context)!.stSignIn,
                                    fontSize: DimensText.buttonText(context),
                                    color: viewModel.isValidButton.value
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            if (viewModel.canUseBiometric.value) ...[
                              SizedBox(width: screenW * 0.03),
                              GlassIconButton(
                                onPressed: viewModel.loginWithBiometric,
                                size: screenH * 0.065,
                                iconSize: screenW * 0.08,
                                icon: const Icon(Icons.fingerprint),
                                useOwnLayer: true,
                                settings: const LiquidGlassSettings(
                                  glassColor: Colors.transparent,
                                  thickness: 60,
                                  blur: 3,
                                  chromaticAberration: 0.3,
                                  lightIntensity: 0.6,
                                  refractiveIndex: 1.59,
                                  saturation: 1.0,
                                  ambientStrength: 1,
                                ),
                              )
                            ]
                          ],
                        )),

                        const Spacer(),

                        Padding(
                          padding: EdgeInsets.only(
                            top: screenH * 0.02,
                            bottom: screenH * 0.02,
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: AppLocalizations.of(context)!.stDontHaveAccount,
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
                                  recognizer: TapGestureRecognizer()..onTap = () {
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
    ));
  }
}