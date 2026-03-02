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
                      horizontal: RecipeMateAppUtil.screenWidth * 0.06,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildProgress(context),
                          const SizedBox(height: 24),
                          _buildTitle(context),
                          const SizedBox(height: 32),
                          
                          _buildInputLabel(context, "SHORT NAME"),
                          customTextFormField(
                            hintText: 'e.g. Alex Dards',
                            context: context,
                            onChanged: viewModel.setName,
                            enableFillColor: ColorVar.white,
                            focusNode: FocusNode(),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          _buildInputLabel(context, "AGE"),
                          customTextFormField(
                            hintText: 'e.g. 25',
                            context: context,
                            onChanged: viewModel.setAge,
                            enableFillColor: ColorVar.white,
                            keyboardType: TextInputType.number,
                            focusNode: FocusNode(),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInputLabel(context, "HEIGHT (CM)"),
                                    customTextFormField(
                                      hintText: '170',
                                      context: context,
                                      onChanged: viewModel.setHeight,
                                      enableFillColor: ColorVar.white,
                                      keyboardType: TextInputType.number,
                                      focusNode: FocusNode(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInputLabel(context, "WEIGHT (KG)"),
                                    customTextFormField(
                                      hintText: '65',
                                      context: context,
                                      onChanged: viewModel.setWeight,
                                      enableFillColor: ColorVar.white,
                                      keyboardType: TextInputType.number,
                                      focusNode: FocusNode(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const Spacer(),
                          const SizedBox(height: 24),
                          _buildNextButton(context, viewModel),
                          const SizedBox(height: 20),
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

  Widget _buildInputLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: customText(
        text: text,
        fontSize: DimensText.microText(context),
        fontWeight: FontWeight.bold,
        color: HexColor(ColorVar.appColor),
      ),
    );
  }

  Widget _buildProgress(BuildContext context) {
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
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: 0.33,
            minHeight: 8,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(HexColor(ColorVar.appColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
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
        const SizedBox(height: 8),
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

  Widget _buildNextButton(BuildContext context, PreferenceFoodViewModel viewModel) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: customElevatedButton(
            onPressed: viewModel.isStep1Valid ? () => Get.toNamed('/preference_food_dua') : null,
            backgroundColor: HexColor(ColorVar.appColor),
            sideColor: HexColor(ColorVar.appColor),
            borderRadius: 16,
            text: "Next",
            fontSize: DimensText.buttonText(context),
            fontColor: Colors.white,
            fontWeight: FontWeight.bold,
            padding: const EdgeInsets.symmetric(vertical: 18)),
      );
    });
  }
}