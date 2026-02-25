import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipemate/utils/dimens_text.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/color_var.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginViewModel vm = Get.put(
      LoginViewModel(
        apiRepository: Get.find<ApiRepository>(),
        context: context,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    RecipeMateAppUtil.init(context);

    final double logoSize = RecipeMateAppUtil.screenWidth * 0.45;
    return Scaffold(
      backgroundColor: HexColor(ColorVar.bgAppColor),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: RecipeMateAppUtil.screenWidth * 0.08,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),

              Image.asset(
                "assets/images/ic_logo_recipemate.png",
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
              ),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),

              customText(
                text: 'Welcome Back',
                fontSize: DimensText.superHeaderText(context),
                fontWeight: FontWeight.w800,
                fontFamily: 'times_new_roman_med_italic',
                color: HexColor(ColorVar.black),
                textAlign: TextAlign.center
              ),

              customText(
                text: "Your smart kitchen assistant awaits.",
                fontSize: DimensText.captionText(context),
                fontWeight: FontWeight.w500,
                color: HexColor(ColorVar.bgGray8),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.05),

              Align(
                alignment: Alignment.centerLeft,
                child: customText(
                  text: "EMAIL ADDRESS",
                  fontSize: DimensText.microText(context),
                  fontWeight: FontWeight.w700,
                  color: HexColor(ColorVar.appColor),
                ),
              ),

              SizedBox(height: 8),

              customTextFormField(
                hintText: 'alex@example.com',
                prefixIcon: Icon(
                  Icons.email_rounded,
                  color: HexColor(ColorVar.appColor),
                ),
                enableFillColor: ColorVar.widgetOrCardBgColor,
                isBorderSide: false,
                doubleVerticalPadding: 18,
                doubleHorizontalPadding: 16,
                doubleTextSize: DimensText.captionText(context),
                context: context,
                onChanged: vm.setNik,
                focusNode: FocusNode(),
              ),

              SizedBox(height: 18),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    text: "PASSWORD",
                    fontSize: DimensText.microText(context),
                    fontWeight: FontWeight.w700,
                    color: HexColor(ColorVar.appColor),
                  ),
                  customText(
                    text: "FORGOT?",
                    fontSize: DimensText.microText(context),
                    fontWeight: FontWeight.w600,
                    color: HexColor(ColorVar.bgGray8),
                  ),
                ],
              ),

              SizedBox(height: 8),

              Obx(() => customTextFormField(
                hintText: "••••••••",
                prefixIcon: Icon(
                  Icons.lock,
                  color: HexColor(ColorVar.appColor),
                ),
                isSuffixIcon: true,
                suffixIcon: Icon(
                  vm.isObscureText.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onSuffixClick: vm.setObscureTextPass,
                enableFillColor: ColorVar.widgetOrCardBgColor,
                isBorderSide: false,
                doubleVerticalPadding: 18,
                doubleHorizontalPadding: 16,
                doubleTextSize: DimensText.captionText(context),
                context: context,
                onChanged: vm.setPass,
                focusNode: FocusNode(),
                ),
              ),

              SizedBox(height: 20),

              Obx(() => SizedBox(
                width: double.infinity,
                child: customElevatedButton(
                  onPressed: vm.isValidButton.value ? vm.onLoginPressed : null,
                  backgroundColor: HexColor(ColorVar.appColor),
                  sideColor: HexColor(ColorVar.appColor),
                  borderRadius: 16,
                  text: "Sign In",
                  icon: const Icon(Icons.arrow_forward),
                  fontSize: RecipeMateAppUtil.screenWidth * 0.04,
                  fontColor: Colors.white,
                  fontWeight: FontWeight.bold,
                  padding: const EdgeInsets.symmetric(vertical: 16)
                ),
              )),

              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: HexColor(ColorVar.borderColor1),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: RecipeMateAppUtil.screenWidth * 0.04,
                    ),
                    child: customText(
                      text: "OR CONTINUE WITH",
                      fontSize: DimensText.captionText(context),
                      fontWeight: FontWeight.w600,
                      color: HexColor(ColorVar.bgGray8),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: HexColor(ColorVar.borderColor1),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Google login
                      },
                      child: Container(
                        height: RecipeMateAppUtil.screenHeight * 0.065,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: HexColor(ColorVar.borderColor1),
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/ic_google.png",
                            height: RecipeMateAppUtil.screenHeight * 0.032,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: RecipeMateAppUtil.screenWidth * 0.04),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Apple login
                      },
                      child: Container(
                        height: RecipeMateAppUtil.screenHeight * 0.065,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: HexColor(ColorVar.borderColor1),
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/ic_apple.png",
                            height: RecipeMateAppUtil.screenHeight * 0.032,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 95),

              Padding(
                padding: EdgeInsets.only(
                  bottom: RecipeMateAppUtil.screenHeight * 0.02,
                  top: RecipeMateAppUtil.screenHeight * 0.01,
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: HexColor(ColorVar.bgGray8),
                      fontSize: DimensText.captionText(context),
                    ),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: HexColor(ColorVar.appColor),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}