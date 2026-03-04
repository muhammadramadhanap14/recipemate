import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../utils/color_var.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/preference_food_view_model.dart';

class PreferenceFoodTigaView extends StatelessWidget {
  PreferenceFoodTigaView({super.key});

  final items = <_StyleFoodItem>[
    _StyleFoodItem("Indonesian", Icons.eco),
    _StyleFoodItem("Western", Icons.severe_cold),
    _StyleFoodItem("Japanese", Icons.hot_tub),
    _StyleFoodItem("Korean", Icons.fitness_center),
  ];

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
      canPop: true,
      child: Scaffold(
          backgroundColor: HexColor(ColorVar.white),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenW * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenH * 0.025),
                  _buildProgress(context, viewModel, screenW, screenH),
                  SizedBox(height: screenH * 0.03),
                  _buildTitle(context, viewModel, screenH),
                  SizedBox(height: screenH * 0.03),
                  Expanded(
                    child: _buildGrid(context, viewModel, screenW, screenH),
                  ),
                  SizedBox(height: screenH * 0.02),
                  _buildFinishButton(context, viewModel, screenW, screenH),
                  SizedBox(height: screenH * 0.025),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildProgress(BuildContext context, PreferenceFoodViewModel viewModel, double screenW, double screenH) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
              text: "STEP 3 OF 3",
              fontSize: DimensText.captionText(context),
              fontWeight: FontWeight.w500,
              color: HexColor(ColorVar.bgGray8),
            ),
            customText(
              text: "100%",
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
            value: 1,
            minHeight: screenH * 0.01,
            backgroundColor: HexColor(ColorVar.bgGray),
            valueColor: AlwaysStoppedAnimation(
                HexColor(ColorVar.appColor)
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, PreferenceFoodViewModel viewModel, double screenH) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
            text: "Tell us your taste!",
            fontSize: DimensText.headerText(context),
            fontWeight: FontWeight.bold,
            color: HexColor(ColorVar.black),
            fontFamily: 'inter_bold'
        ),

        SizedBox(height: screenH * 0.01),

        customText(
            text: "What are your favorite food types or dietary preferences?",
            fontSize: DimensText.captionText(context),
            fontWeight: FontWeight.w500,
            color: HexColor(ColorVar.bgGray8),
            intMaxLine: null
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, PreferenceFoodViewModel viewModel, double screenW, double screenH) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: screenH * 0.02,
        crossAxisSpacing: screenW * 0.04,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return Obx(() {
          final bool selected = viewModel.selectedStyleDietary.contains(item.label);
          return GestureDetector(
            onTap: () => viewModel.toggleStyleDietary(item.label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: HexColor(ColorVar.white),
                borderRadius: BorderRadius.circular(screenW * 0.04),
                border: Border.all(
                  color: selected ? HexColor(ColorVar.appColor) : HexColor(ColorVar.bgGray),
                  width: selected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: screenW * 0.02,
                    offset: Offset(0, screenH * 0.004),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenW * 0.14,
                    height: screenW * 0.14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? HexColor(ColorVar.appColor).withValues(alpha: 0.1)
                          : HexColor(ColorVar.bgGray).withValues(alpha: 0.3),
                    ),
                    child: Icon(
                      item.icon,
                      size: screenW * 0.07,
                      color: selected ? HexColor(ColorVar.appColor) : HexColor(ColorVar.bgGray8),
                    ),
                  ),
                  SizedBox(height: screenH * 0.015),
                  customText(
                    text: item.label,
                    fontSize: DimensText.bodySmallText(context),
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: HexColor(ColorVar.black),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildFinishButton(BuildContext context, PreferenceFoodViewModel viewModel, double screenW, double screenH) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: customElevatedButton(
            onPressed: viewModel.isStep3Valid ? () => Get.offAllNamed('/home') : null,
            backgroundColor: HexColor(ColorVar.appColor),
            sideColor: HexColor(ColorVar.appColor),
            borderRadius: screenW * 0.04,
            text: "Finish!",
            fontSize: DimensText.buttonText(context),
            fontColor: HexColor(ColorVar.white),
            fontWeight: FontWeight.bold,
            padding: EdgeInsets.symmetric(vertical: screenH * 0.022)),
      );
    });
  }
}

class _StyleFoodItem {
  final String label;
  final IconData icon;
  _StyleFoodItem(this.label, this.icon);
}