import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/utils/dimens_text.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/recipemate_app_util.dart';
import '../view_model/preference_food_view_model.dart';

class PreferenceFoodDuaView extends StatelessWidget {
  PreferenceFoodDuaView({super.key});

  final items = <_FoodItem>[
    _FoodItem("Vegan", Icons.eco),
    _FoodItem("Keto", Icons.fitness_center),
    _FoodItem("Seafood", Icons.set_meal),
    _FoodItem("Spicy Food", Icons.local_fire_department),
    _FoodItem("Desserts", Icons.icecream),
    _FoodItem("Healthy", Icons.favorite),
    _FoodItem("Gluten-Free", Icons.grain),
    _FoodItem("Mediterranean", Icons.restaurant),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              _buildNextButton(context, viewModel, screenW, screenH),
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
              text: AppLocalizations.of(context)!.stStep2of3,
              fontSize: DimensText.captionText(context),
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
            ),
            customText(
              text: "66%",
              fontSize: DimensText.captionText(context),
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary
            ),
          ],
        ),

        SizedBox(height: screenH * 0.01),

        ClipRRect(
          borderRadius: BorderRadius.circular(screenW * 0.025),
          child: LinearProgressIndicator(
            value: 0.66,
            minHeight: screenH * 0.01,
            backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
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
          text: AppLocalizations.of(context)!.stgreetPrefFood3,
          fontSize: DimensText.headerText(context),
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: 'inter_bold'
        ),

        SizedBox(height: screenH * 0.01),

        customText(
          text: AppLocalizations.of(context)!.stgreetPrefFood4,
          fontSize: DimensText.captionText(context),
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
          final bool selected = viewModel.selectedDietary.contains(item.label);
          return GestureDetector(
            onTap: () => viewModel.toggleDietary(item.label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(screenW * 0.04),
                border: Border.all(
                  color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  width: selected ? 2 : 1,
                ),
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
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    child: Icon(
                      item.icon,
                      size: screenW * 0.07,
                      color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: screenH * 0.015),
                  customText(
                    text: item.label,
                    fontSize: DimensText.bodySmallText(context),
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildNextButton(BuildContext context, PreferenceFoodViewModel viewModel, double screenW, double screenH) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: customElevatedButton(
          onPressed: viewModel.isStep2Valid ? () => Get.toNamed('/preference_food_tiga') : null,
          backgroundColor: Theme.of(context).colorScheme.primary,
          sideColor: Theme.of(context).colorScheme.primary,
          borderRadius: screenW * 0.04,
          text: AppLocalizations.of(context)!.stNextBtn,
          fontSize: DimensText.buttonText(context),
          fontColor: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          padding: EdgeInsets.symmetric(vertical: screenH * 0.022)),
      );
    });
  }
}

class _FoodItem {
  final String label;
  final IconData icon;
  _FoodItem(this.label, this.icon);
}