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
                              text: AppLocalizations.of(context)!.stRegister,
                              fontSize: DimensText.superHeaderText(context),
                              fontWeight: FontWeight.w800,
                              fontFamily: 'times_new_roman_med_italic',
                              color: Theme.of(context).colorScheme.onSurface,
                              textAlign: TextAlign.center
                          ),

                          customText(
                            text: AppLocalizations.of(context)!.stRegisterGreet,
                            fontSize: DimensText.captionText(context),
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: screenH * 0.05),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: customText(
                              text: AppLocalizations.of(context)!.stFullName,
                              fontSize: DimensText.microText(context),
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),

                          SizedBox(height: screenH * 0.01),

                          GlassTextField(
                            height: RecipeMateAppUtil.screenHeight * 0.065,
                            focusNode: viewModel.fullnameFocusNode,
                            keyboardType: TextInputType.name,
                            onChanged: viewModel.setFullname,
                            placeholder: 'Alex Darmono',
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
                              Icons.person,
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
                              fontFamily: 'Poppins-Regular',
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

                          Align(
                            alignment: Alignment.centerLeft,
                            child: customText(
                              text: AppLocalizations.of(context)!.stPassword,
                              fontSize: DimensText.microText(context),
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
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

                          Obx(() => SizedBox(
                            child: GlassButton.custom(
                              onTap: viewModel.onRegisterPressed,
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
                                  text: AppLocalizations.of(context)!.stSignUp,
                                  fontSize: DimensText.buttonText(context),
                                  color: viewModel.isValidButton.value
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                                text: AppLocalizations.of(context)!.stAlreadyHaveAccount,
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
                                    recognizer: TapGestureRecognizer()..onTap = () {
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