import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../utils/color_var.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/preference_food_view_model.dart';

class PreferenceFoodSatuView extends StatelessWidget {
  const PreferenceFoodSatuView({super.key});

  @override
  Widget build(BuildContext context) {
    final PreferenceFoodViewModel viewModel = Get.put(PreferenceFoodViewModel());
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RecipeMateAppUtil.lockToPortrait();
    });

    final double screenW = RecipeMateAppUtil.screenWidth;
    final double screenH = RecipeMateAppUtil.screenHeight;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: HexColor(ColorVar.bgAppColor),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenW * 0.06,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenH * 0.025),
                          _buildProgress(context, screenW, screenH),
                          SizedBox(height: screenH * 0.03),
                          _buildTitle(context, screenH),
                          SizedBox(height: screenH * 0.04),
                          
                          _buildInputLabel(context, "SHORT NAME", screenW, screenH),
                          customTextFormField(
                            hintText: 'e.g. Alex Dards',
                            context: context,
                            onChanged: viewModel.setName,
                            enableFillColor: ColorVar.white,
                            focusNode: FocusNode(),
                            doubleVerticalPadding: screenH * 0.02,
                            doubleHorizontalPadding: screenW * 0.04,
                            doubleTextSize: DimensText.captionText(context),
                          ),
                          
                          SizedBox(height: screenH * 0.025),
                          
                          _buildInputLabel(context, "AGE", screenW, screenH),
                          customTextFormField(
                            hintText: 'e.g. 25',
                            context: context,
                            onChanged: viewModel.setAge,
                            enableFillColor: ColorVar.white,
                            keyboardType: TextInputType.number,
                            focusNode: FocusNode(),
                            doubleVerticalPadding: screenH * 0.02,
                            doubleHorizontalPadding: screenW * 0.04,
                            doubleTextSize: DimensText.captionText(context),
                          ),
                          
                          SizedBox(height: screenH * 0.025),
                          
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInputLabel(context, "HEIGHT (CM)", screenW, screenH),
                                    customTextFormField(
                                      hintText: '170',
                                      context: context,
                                      onChanged: viewModel.setHeight,
                                      enableFillColor: ColorVar.white,
                                      keyboardType: TextInputType.number,
                                      focusNode: FocusNode(),
                                      doubleVerticalPadding: screenH * 0.02,
                                      doubleHorizontalPadding: screenW * 0.04,
                                      doubleTextSize: DimensText.captionText(context),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: screenW * 0.04),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInputLabel(context, "WEIGHT (KG)", screenW, screenH),
                                    customTextFormField(
                                      hintText: '65',
                                      context: context,
                                      onChanged: viewModel.setWeight,
                                      enableFillColor: ColorVar.white,
                                      keyboardType: TextInputType.number,
                                      focusNode: FocusNode(),
                                      doubleVerticalPadding: screenH * 0.02,
                                      doubleHorizontalPadding: screenW * 0.04,
                                      doubleTextSize: DimensText.captionText(context),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const Spacer(),
                          SizedBox(height: screenH * 0.03),
                          _buildNextButton(context, viewModel, screenW, screenH),
                          SizedBox(height: screenH * 0.025),
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

  Widget _buildInputLabel(BuildContext context, String text, double screenW, double screenH) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenH * 0.01, left: screenW * 0.01),
      child: customText(
        text: text,
        fontSize: DimensText.microText(context),
        fontWeight: FontWeight.bold,
        color: HexColor(ColorVar.appColor),
      ),
    );
  }

  Widget _buildProgress(BuildContext context, double screenW, double screenH) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
              text: "STEP 1 OF 3",
              fontSize: DimensText.captionText(context),
              fontWeight: FontWeight.w500,
              color: HexColor(ColorVar.bgGray8),
            ),
            customText(
              text: "33%",
              fontSize: DimensText.captionText(context),
              fontWeight: FontWeight.w500,
              color: HexColor(ColorVar.appColor),
            ),
          ],
        ),
        SizedBox(height: screenH * 0.01),
        ClipRRect(
          borderRadius: BorderRadius.circular(screenW * 0.025),
          child: LinearProgressIndicator(
            value: 0.33,
            minHeight: screenH * 0.01,
            backgroundColor: HexColor(ColorVar.white),
            valueColor: AlwaysStoppedAnimation(HexColor(ColorVar.appColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, double screenH) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: "Tell us about yourself!",
          fontSize: DimensText.headerText(context),
          fontWeight: FontWeight.bold,
          color: HexColor(ColorVar.black),
          fontFamily: 'inter_bold',
        ),
        SizedBox(height: screenH * 0.01),
        customText(
          text: "Help us personalize your experience by providing some basic information.",
          fontSize: DimensText.captionText(context),
          fontWeight: FontWeight.w500,
          color: HexColor(ColorVar.bgGray8),
          intMaxLine: null,
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context, PreferenceFoodViewModel viewModel, double screenW, double screenH) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: customElevatedButton(
            onPressed: viewModel.isStep1Valid ? () => Get.toNamed('/preference_food_dua') : null,
            backgroundColor: HexColor(ColorVar.appColor),
            sideColor: HexColor(ColorVar.appColor),
            borderRadius: screenW * 0.04,
            text: "Next",
            fontSize: DimensText.buttonText(context),
            fontColor: HexColor(ColorVar.white),
            fontWeight: FontWeight.bold,
            padding: EdgeInsets.symmetric(vertical: screenH * 0.022)),
      );
    });
  }
}