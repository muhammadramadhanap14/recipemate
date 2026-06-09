import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
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

                        TextFormField(
                          focusNode: FocusNode(),
                          keyboardType: TextInputType.name,
                          onChanged: viewModel.setFullname,
                          style: TextStyle(
                            fontSize: DimensText.captionText(context),
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Alex Darmono',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                              size: screenW * 0.06,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: screenH * 0.022,
                              horizontal: screenW * 0.04,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
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

                        TextFormField(
                          focusNode: FocusNode(),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: viewModel.setEmail,
                          style: TextStyle(
                            fontSize: DimensText.captionText(context),
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: "alex@example.com",
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            prefixIcon: Icon(
                              Icons.email_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: screenW * 0.06,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: screenH * 0.022,
                              horizontal: screenW * 0.04,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
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

                        Obx(() => TextFormField(
                          focusNode: FocusNode(),
                          obscureText: viewModel.isObscureText.value,
                          onChanged: viewModel.setPassword,
                          style: TextStyle(
                            fontSize: DimensText.captionText(context),
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: "••••••••",
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).colorScheme.primary,
                              size: screenW * 0.06,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                viewModel.isObscureText.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: viewModel.togglePasswordVisibility,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: screenH * 0.022,
                              horizontal: screenW * 0.04,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        )),

                        SizedBox(height: screenH * 0.025),

                        Obx(() => SizedBox(
                          width: double.infinity,
                          child: customElevatedButton(
                            onPressed: viewModel.isValidButton.value ? viewModel.onRegisterPressed : null,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            sideColor: Theme.of(context).colorScheme.primary,
                            borderRadius: screenW * 0.04,
                            text: AppLocalizations.of(context)!.stSignUp,
                            fontSize: DimensText.buttonText(context),
                            fontColor: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            padding: EdgeInsets.symmetric(
                              vertical: screenH * 0.02,
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
    );
  }
}