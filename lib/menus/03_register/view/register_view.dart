import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipemate/menus/03_register/view_model/register_view_model.dart';
import 'package:recipemate/utils/dimens_text.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/color_var.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    RecipeMateAppUtil.init(context);
    final RegisterViewModel vm = Get.put(
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
      backgroundColor: HexColor(ColorVar.bgAppColor),
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
                            text: 'Create Account',
                            fontSize: DimensText.superHeaderText(context),
                            fontWeight: FontWeight.w800,
                            fontFamily: 'times_new_roman_med_italic',
                            color: HexColor(ColorVar.black),
                            textAlign: TextAlign.center
                        ),

                        customText(
                          text: "Start your smart cooking journey today.",
                          fontSize: DimensText.captionText(context),
                          fontWeight: FontWeight.w500,
                          color: HexColor(ColorVar.bgGray8),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: screenH * 0.05),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: customText(
                            text: "FULL NAME",
                            fontSize: DimensText.microText(context),
                            fontWeight: FontWeight.w700,
                            color: HexColor(ColorVar.appColor),
                          ),
                        ),

                        SizedBox(height: screenH * 0.01),

                        customTextFormField(
                          hintText: 'Alex Darmono',
                          prefixIcon: Icon(
                            Icons.person,
                            color: HexColor(ColorVar.appColor),
                            size: screenW * 0.06,
                          ),
                          enableFillColor: ColorVar.widgetOrCardBgColor,
                          isBorderSide: false,
                          doubleVerticalPadding: screenH * 0.022,
                          doubleHorizontalPadding: screenW * 0.04,
                          doubleTextSize: DimensText.captionText(context),
                          context: context,
                          onChanged: vm.setFullname,
                          focusNode: FocusNode(),
                        ),

                        SizedBox(height: screenH * 0.022),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: customText(
                            text: "EMAIL ADDRESS",
                            fontSize: DimensText.microText(context),
                            fontWeight: FontWeight.w700,
                            color: HexColor(ColorVar.appColor),
                          ),
                        ),

                        SizedBox(height: screenH * 0.01),

                        customTextFormField(
                          hintText: 'alex@example.com',
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: HexColor(ColorVar.appColor),
                            size: screenW * 0.06,
                          ),
                          enableFillColor: ColorVar.widgetOrCardBgColor,
                          isBorderSide: false,
                          doubleVerticalPadding: screenH * 0.022,
                          doubleHorizontalPadding: screenW * 0.04,
                          doubleTextSize: DimensText.captionText(context),
                          context: context,
                          onChanged: vm.setUsername,
                          focusNode: FocusNode(),
                        ),

                        SizedBox(height: screenH * 0.022),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: customText(
                            text: "PASSWORD",
                            fontSize: DimensText.microText(context),
                            fontWeight: FontWeight.w700,
                            color: HexColor(ColorVar.appColor),
                          ),
                        ),

                        SizedBox(height: screenH * 0.01),

                        Obx(() => customTextFormField(
                          hintText: "••••••••",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: HexColor(ColorVar.appColor),
                            size: screenW * 0.06,
                          ),
                          isSuffixIcon: true,
                          suffixIcon: Icon(
                            vm.isObscureText.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: screenW * 0.06,
                          ),
                          onSuffixClick: vm.togglePasswordVisibility,
                          enableFillColor: ColorVar.widgetOrCardBgColor,
                          isBorderSide: false,
                          doubleVerticalPadding: screenH * 0.022,
                          doubleHorizontalPadding: screenW * 0.04,
                          doubleTextSize: DimensText.captionText(context),
                          context: context,
                          obscureText: vm.isObscureText.value,
                          onChanged: vm.setPassword,
                          focusNode: FocusNode(),
                        )),

                        SizedBox(height: screenH * 0.025),

                        Obx(() => SizedBox(
                          width: double.infinity,
                          child: customElevatedButton(
                              onPressed: vm.isValidButton.value ? vm.onLoginPressed : null,
                              backgroundColor: HexColor(ColorVar.appColor),
                              sideColor: HexColor(ColorVar.appColor),
                              borderRadius: screenW * 0.04,
                              text: "Sign Up",
                              fontSize: DimensText.buttonText(context),
                              fontColor: HexColor(ColorVar.white),
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
                              text: "Already have an account? ",
                              style: TextStyle(
                                color: HexColor(ColorVar.bgGray8),
                                fontSize: DimensText.captionText(context),
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(
                                    color: HexColor(ColorVar.appColor),
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