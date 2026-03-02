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
    _StyleFoodItem("Western", Icons.fitness_center),
    _StyleFoodItem("Japanese", Icons.eco),
    _StyleFoodItem("Korean", Icons.fitness_center),
  ];

  @override
  Widget build(BuildContext context) {
    final PreferenceFoodViewModel viewModel = Get.put(PreferenceFoodViewModel(),);
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RecipeMateAppUtil.lockToPortrait();
    });

    return PopScope(
      canPop: true,
      child: Scaffold(
          backgroundColor: HexColor(ColorVar.white),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: RecipeMateAppUtil.screenWidth * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildProgress(context, viewModel),
                  const SizedBox(height: 24),
                  _buildTitle(context, viewModel),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildGrid(context, viewModel),
                  ),
                  const SizedBox(height: 16),
                  _buildFinishButton(context, viewModel),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildProgress(BuildContext context, PreferenceFoodViewModel viewModel) {
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

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: 1,
            minHeight: 8,
            backgroundColor: HexColor(ColorVar.white),
            valueColor: AlwaysStoppedAnimation(
                HexColor(ColorVar.appColor)
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, PreferenceFoodViewModel viewModel) {
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

        SizedBox(height: 8),

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

  Widget _buildGrid(BuildContext context, PreferenceFoodViewModel viewModel) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? HexColor(ColorVar.appColor) : const Color(0xFFE5E7EB),
                  width: selected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? HexColor(ColorVar.appColor).withValues(alpha: 0.1)
                          : const Color(0xFFF3F4F6),
                    ),
                    child: Icon(
                      item.icon,
                      size: 26,
                      color: selected ? HexColor(ColorVar.appColor) : HexColor(ColorVar.bgGray),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildFinishButton(BuildContext context, PreferenceFoodViewModel viewModel) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: customElevatedButton(
            onPressed: viewModel.isStep3Valid ? () => Get.toNamed('/home') : null,
            backgroundColor: HexColor(ColorVar.appColor),
            sideColor: HexColor(ColorVar.appColor),
            borderRadius: 16,
            text: "Finish!",
            fontSize: DimensText.buttonText(context),
            fontColor: Colors.white,
            fontWeight: FontWeight.bold,
            padding: const EdgeInsets.symmetric(vertical: 18)),
      );
    });
  }
}

class _StyleFoodItem {
  final String label;
  final IconData icon;
  _StyleFoodItem(this.label, this.icon);
}