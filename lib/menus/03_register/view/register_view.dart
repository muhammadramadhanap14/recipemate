import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/menus/03_register/view_model/register_view_model.dart';
import 'package:recipemate/utils/dimens_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    RecipeMateAppUtil.init(context);
    final RegisterViewModel viewModel = Get.put(
      RegisterViewModel(
        apiRepository: Get.find<ApiRepository>(),
        context: context,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    final double screenW = RecipeMateAppUtil.screenWidth;
    final double screenH = RecipeMateAppUtil.screenHeight;
    final double logoSize = screenW * 0.35;

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
                          SizedBox(height: screenH * 0.04),

                          Image.asset(
                            "assets/images/ic_logo_recipemate.png",
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: screenH * 0.02),

                          customText(
                            text: AppLocalizations.of(context)!.stRegister,
                            fontSize: DimensText.superHeaderText(context) * 1.0,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'times_new_roman_med_italic',
                            color: Theme.of(context).colorScheme.onSurface,
                            textAlign: TextAlign.center,
                            intMaxLine: null,
                          ),

                          SizedBox(height: screenH * 0.005),

                          customText(
                            text: AppLocalizations.of(context)!.stRegisterGreet,
                            fontSize: DimensText.captionText(context),
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: screenH * 0.04),

                          // Email Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                text: AppLocalizations.of(context)!.stEmailAddress,
                                fontSize: DimensText.captionText(context),
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
                              SizedBox(height: screenH * 0.008),
                              GlassTextField(
                                controller: viewModel.emailController,
                                focusNode: viewModel.emailFocusNode,
                                placeholder: 'name@example.com',
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                height: screenH * 0.065,
                                shape: LiquidRoundedRectangle(borderRadius: screenW * 0.04),
                                prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                settings: const LiquidGlassSettings(
                                  glassColor: Colors.transparent,
                                  thickness: 100,
                                  blur: 3,
                                  chromaticAberration: 0.3,
                                  lightIntensity: 0.8,
                                  refractiveIndex: 1.59,
                                  saturation: 1.0,
                                  ambientStrength: 1,
                                  edgeAbsorption: 0.15,
                                ),
                              ),
                              Obx(() => viewModel.emailError.value.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 4, left: 8),
                                      child: customText(
                                        text: viewModel.emailError.value,
                                        fontSize: DimensText.microText(context),
                                        color: Colors.redAccent,
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                            ],
                          ),

                          SizedBox(height: screenH * 0.02),

                          // Password Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                text: AppLocalizations.of(context)!.stPassword,
                                fontSize: DimensText.captionText(context),
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
                              SizedBox(height: screenH * 0.008),
                              Obx(() => GlassTextField(
                                controller: viewModel.passwordController,
                                focusNode: viewModel.passwordFocusNode,
                                placeholder: '••••••••',
                                obscureText: viewModel.isPasswordHidden.value,
                                textInputAction: TextInputAction.next,
                                height: screenH * 0.065,
                                shape: LiquidRoundedRectangle(borderRadius: screenW * 0.04),
                                prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                suffixIcon: Icon(
                                  viewModel.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                onSuffixTap: viewModel.togglePasswordVisibility,
                                settings: const LiquidGlassSettings(
                                  glassColor: Colors.transparent,
                                  thickness: 100,
                                  blur: 3,
                                  chromaticAberration: 0.3,
                                  lightIntensity: 0.8,
                                  refractiveIndex: 1.59,
                                  saturation: 1.0,
                                  ambientStrength: 1,
                                  edgeAbsorption: 0.15,
                                ),
                              )),
                              Obx(() => viewModel.passwordError.value.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 4, left: 8),
                                      child: customText(
                                        text: viewModel.passwordError.value,
                                        fontSize: DimensText.microText(context),
                                        color: Colors.redAccent,
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                            ],
                          ),

                          SizedBox(height: screenH * 0.02),

                          // Confirm Password Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                text: AppLocalizations.of(context)!.stConfirmPassword,
                                fontSize: DimensText.captionText(context),
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
                              SizedBox(height: screenH * 0.008),
                              Obx(() => GlassTextField(
                                controller: viewModel.confirmPasswordController,
                                focusNode: viewModel.confirmPasswordFocusNode,
                                placeholder: '••••••••',
                                obscureText: viewModel.isConfirmPasswordHidden.value,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => viewModel.onEmailRegisterPressed(),
                                height: screenH * 0.065,
                                shape: LiquidRoundedRectangle(borderRadius: screenW * 0.04),
                                prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                suffixIcon: Icon(
                                  viewModel.isConfirmPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                onSuffixTap: viewModel.toggleConfirmPasswordVisibility,
                                settings: const LiquidGlassSettings(
                                  glassColor: Colors.transparent,
                                  thickness: 100,
                                  blur: 3,
                                  chromaticAberration: 0.3,
                                  lightIntensity: 0.8,
                                  refractiveIndex: 1.59,
                                  saturation: 1.0,
                                  ambientStrength: 1,
                                  edgeAbsorption: 0.15,
                                ),
                              )),
                              Obx(() => viewModel.confirmPasswordError.value.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 4, left: 8),
                                      child: customText(
                                        text: viewModel.confirmPasswordError.value,
                                        fontSize: DimensText.microText(context),
                                        color: Colors.redAccent,
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                            ],
                          ),

                          SizedBox(height: screenH * 0.03),

                          // Email Register Button
                          Obx(() => GlassButton.custom(
                            onTap: () => viewModel.onEmailRegisterPressed(),
                            enabled: !viewModel.isLoading.value,
                            width: double.infinity,
                            height: screenH * 0.065,
                            shape: LiquidRoundedRectangle(borderRadius: screenW * 0.04),
                            style: GlassButtonStyle.filled,
                            useOwnLayer: true,
                            settings: LiquidGlassSettings(
                              glassColor: Theme.of(context).colorScheme.primary,
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
                              child: viewModel.isLoading.value
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                                  : customText(
                                text: AppLocalizations.of(context)!.stSignUpWithEmail,
                                fontSize: DimensText.buttonSmallText(context),
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),

                          SizedBox(height: screenH * 0.02),

                          customText(
                            text: "By signing up, you agree to our Terms of Service and Privacy Policy.",
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
                                text: '${AppLocalizations.of(context)!.stAlreadyHaveAccount} ',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontSize: DimensText.captionText(context),
                                ),
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!.stSignIn,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.offNamed('/login');
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
