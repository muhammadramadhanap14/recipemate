import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/menus/02_login/view_model/email_verification_view_model.dart';
import 'package:recipemate/utils/dimens_text.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';

class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    RecipeMateAppUtil.init(context);
    final EmailVerificationViewModel viewModel = Get.put(EmailVerificationViewModel());

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
        ],
      ),
      body: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenW * 0.08),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/ic_logo_recipemate.png",
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: screenH * 0.04),
                    customText(
                      text: AppLocalizations.of(context)!.stVerifyEmailTitle,
                      fontSize: DimensText.superHeaderText(context),
                      fontWeight: FontWeight.w800,
                      fontFamily: 'times_new_roman_med_italic',
                      color: Theme.of(context).colorScheme.onSurface,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenH * 0.02),
                    customText(
                      text: AppLocalizations.of(context)!.stVerifyEmailMessage,
                      fontSize: DimensText.captionText(context),
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      textAlign: TextAlign.center,
                      intMaxLine: null,
                    ),
                    SizedBox(height: screenH * 0.06),
                    SizedBox(
                      width: double.infinity,
                      height: screenH * 0.065,
                      child: customElevatedButton(
                        onPressed: viewModel.checkVerification,
                        text: AppLocalizations.of(context)!.stAlreadyVerifiedBtn,
                        fontSize: DimensText.buttonSmallText(context),
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w600,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        sideColor: Theme.of(context).colorScheme.primary,
                        fontColor: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: screenW * 0.04,
                      ),
                    ),
                    SizedBox(height: screenH * 0.02),
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: screenH * 0.065,
                      child: customElevatedButton(
                        onPressed: viewModel.resendCooldown.value > 0 ? null : viewModel.resendEmail,
                        text: viewModel.resendCooldown.value > 0
                            ? 'Kirim ulang dalam ${viewModel.resendCooldown.value}dtk'
                            : AppLocalizations.of(context)!.stResendEmailBtn,
                        fontSize: DimensText.buttonSmallText(context),
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w600,
                        backgroundColor: Theme.of(context).cardColor,
                        sideColor: Theme.of(context).cardColor,
                        fontColor: Theme.of(context).colorScheme.onSurface,
                        borderRadius: screenW * 0.04,
                      ),
                    )),
                    SizedBox(height: screenH * 0.02),
                    TextButton(
                      onPressed: viewModel.signOut,
                      child: customText(
                        text: AppLocalizations.of(context)!.logout,
                        fontSize: DimensText.captionText(context),
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
