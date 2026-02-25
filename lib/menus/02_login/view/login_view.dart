import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/color_var.dart';
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

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.06),

              Container(
                width: RecipeMateAppUtil.screenWidth * 0.22,
                height: RecipeMateAppUtil.screenWidth * 0.22,
                decoration: BoxDecoration(
                  color: HexColor(ColorVar.appColor),
                  borderRadius: BorderRadius.circular(
                    RecipeMateAppUtil.screenWidth * 0.08,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor(ColorVar.appColor).withValues(alpha: 0.35),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: RecipeMateAppUtil.screenWidth * 0.11,
                ),
              ),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.035),

              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: RecipeMateAppUtil.screenWidth * 0.055,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Recipe'),
                    TextSpan(
                      text: 'Mate',
                      style: TextStyle(
                        color: HexColor(ColorVar.appColor),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.025),

              customText(
                text: 'Welcome Back',
                fontSize: RecipeMateAppUtil.screenWidth * 0.075,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.007),

              customText(
                text: 'Your smart kitchen assistant awaits.',
                fontSize: RecipeMateAppUtil.screenWidth * 0.030,
                fontWeight: FontWeight.w600,
                color: HexColor(ColorVar.bgGray8),
                textAlign: TextAlign.center,
                isSoftWrap: true,
              ),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.045),

              Align(
                alignment: Alignment.centerLeft,
                child: customText(
                  text: 'EMAIL ADDRESS',
                  fontSize: RecipeMateAppUtil.screenWidth * 0.02,
                  fontWeight: FontWeight.w700,
                  color: HexColor(ColorVar.appColor),
                ),
              ),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.008),

              customTextFormField(
                hintText: 'alex@example.com',
                prefixIcon: Icon(
                  Icons.email,
                  color: HexColor(ColorVar.appColor),
                ),
                enableFillColor: ColorVar.widgetOrCardBgColor,
                isBorderSide: false,
                doubleVerticalPadding: RecipeMateAppUtil.screenHeight * 0.020,
                doubleHorizontalPadding: RecipeMateAppUtil.screenWidth * 0.05,
                doubleTextSize: RecipeMateAppUtil.screenWidth * 0.04,
                context: context,
                onChanged: vm.setNik,
                focusNode: FocusNode(),
              ),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.01),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    text: 'PASSWORD',
                    fontSize: RecipeMateAppUtil.screenWidth * 0.02,
                    fontWeight: FontWeight.w700,
                    color: HexColor(ColorVar.appColor),
                  ),
                  customText(
                    text: 'FORGOT?',
                    fontSize: RecipeMateAppUtil.screenWidth * 0.02,
                    fontWeight: FontWeight.w600,
                    color: HexColor(ColorVar.bgGray8),
                  ),
                ],
              ),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.008),

              Obx(() => customTextFormField(
                hintText: '••••••••',
                prefixIcon: Icon(
                  Icons.lock,
                  color: HexColor(ColorVar.appColor),
                ),
                isSuffixIcon: true,
                suffixIcon: Icon(
                  vm.isObscureText.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: HexColor(ColorVar.bgGray8),
                ),
                onSuffixClick: vm.setObscureTextPass,
                enableFillColor: ColorVar.widgetOrCardBgColor,
                isBorderSide: false,
                doubleVerticalPadding: RecipeMateAppUtil.screenHeight * 0.020,
                doubleHorizontalPadding: RecipeMateAppUtil.screenWidth * 0.05,
                doubleTextSize: RecipeMateAppUtil.screenWidth * 0.04,
                context: context,
                onChanged: vm.setPass,
                focusNode: FocusNode(),
              )),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.025),

              Obx(() => SizedBox(
                width: double.infinity,
                child: customElevatedButton(
                  onPressed: vm.isValidButton.value ? vm.onLoginPressed : null,
                  backgroundColor: HexColor(ColorVar.appColor),
                  sideColor: HexColor(ColorVar.appColor),
                  borderRadius: RecipeMateAppUtil.screenWidth * 0.06,
                  text: 'Sign In',
                  icon: const Icon(Icons.arrow_forward_rounded),
                  fontSize: RecipeMateAppUtil.screenWidth * 0.04,
                  fontColor: Colors.white,
                  fontWeight: FontWeight.bold,
                  padding: EdgeInsets.symmetric(
                    vertical: RecipeMateAppUtil.screenHeight * 0.012,
                  ),
                ),
              )),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.025),

              Row(
                children: [
                  Expanded(child: Divider(color: HexColor(ColorVar.borderColor1))),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: RecipeMateAppUtil.screenWidth * 0.03,
                    ),
                    child: customText(
                      text: 'OR CONTINUE WITH',
                      fontSize: RecipeMateAppUtil.screenWidth * 0.03,
                      color: HexColor(ColorVar.bgGray8),
                    ),
                  ),
                  Expanded(child: Divider(color: HexColor(ColorVar.borderColor1))),
                ],
              ),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.04),

              Row(
                children: [
                  Expanded(
                    child: customOutlinedButton(
                      onPressed: () {},
                      borderColor: HexColor(ColorVar.borderColor1),
                      borderRadius: RecipeMateAppUtil.screenWidth * 0.08,
                      text: 'G',
                      fontColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: RecipeMateAppUtil.screenWidth * 0.04),
                  Expanded(
                    child: customOutlinedButton(
                      onPressed: () {},
                      borderColor: HexColor(ColorVar.borderColor1),
                      borderRadius: RecipeMateAppUtil.screenWidth * 0.08,
                      text: '',
                      fontColor: Colors.black,
                    ),
                  ),
                ],
              ),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.06),

              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                    color: HexColor(ColorVar.bgGray8),
                    fontSize: RecipeMateAppUtil.screenWidth * 0.035,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        color: HexColor(ColorVar.appColor),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}