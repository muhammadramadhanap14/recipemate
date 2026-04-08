import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/model_response/detail_recipe_response.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/no_data_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../../../utils/view_utils/connection_wrapper.dart';
import '../view_model/home_detail_view_model.dart';

class HomeDetailView extends StatelessWidget {
  const HomeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final int recipeId = Get.arguments as int;
    final HomeDetailViewModel viewModel = Get.put(
      HomeDetailViewModel(
        apiRepository: Get.find<ApiRepository>(),
        recipeId: recipeId,
      )
    );
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });
    return ConnectionWrapper(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Obx(() {
          if (viewModel.isLoading.value) {
            return Center(child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ));
          }
          final DetailRecipeResponse? recipe = viewModel.recipeDetail.value;
          if (recipe == null) {
            return const Center(child: NoDataUtil());
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageHeader(context, recipe.image ?? ""),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
                      _buildTitleSection(context, recipe),
                      SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
                      _buildNutritionalCard(context, recipe),
                      SizedBox(height: RecipeMateAppUtil.screenHeight * 0.04),
                      _buildIngredientsSection(context, recipe.extendedIngredients ?? []),
                      SizedBox(height: RecipeMateAppUtil.screenHeight * 0.05),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context, String imageUrl) {
    return Stack(
      children: [
        Container(
          height: RecipeMateAppUtil.screenHeight * 0.45,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: RecipeMateAppUtil.screenWidth * 0.04,
              vertical: RecipeMateAppUtil.screenHeight * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(
                  context: context,
                  onTap: () => Get.back(),
                  icon: Icons.chevron_left,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({required BuildContext context, required VoidCallback onTap, required IconData icon, Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.02),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? Theme.of(context).colorScheme.onPrimary,
          size: RecipeMateAppUtil.screenWidth * 0.07,
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, DetailRecipeResponse recipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: recipe.title ?? "",
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: DimensText.headerText(context),
          fontWeight: FontWeight.bold,
          fontFamily: 'times_new_roman_bold',
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
        Row(
          children: [
            Icon(
              Icons.access_time_filled, 
              color: Theme.of(context).colorScheme.primary,
              size: RecipeMateAppUtil.screenWidth * 0.05
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.015),
            customText(
              text: "${recipe.readyInMinutes} mins", 
              fontSize: DimensText.captionText(context), 
              color: Theme.of(context).colorScheme.onSurface
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.04),
            Icon(
              Icons.star, 
              color: Theme.of(context).colorScheme.primary,
              size: RecipeMateAppUtil.screenWidth * 0.05
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.015),
            customText(
              text: "Score: ${recipe.spoonacularScore?.toStringAsFixed(1) ?? "0"}",
              fontSize: DimensText.captionText(context),
              color: Theme.of(context).colorScheme.onSurface
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionalCard(BuildContext context, DetailRecipeResponse recipe) {
    final nutrients = recipe.nutrition?.nutrients ?? [];
    final kcalNutrient = nutrients.firstWhere(
      (n) => n.name == "Calories", 
      orElse: () => Nutrients(amount: 0, percentOfDailyNeeds: 0)
    );
    
    final kcal = kcalNutrient.amount;
    final kcalPercent = ((kcalNutrient.percentOfDailyNeeds ?? 0) / 100).clamp(0.0, 1.0);
    final protein = nutrients.firstWhere((n) => n.name == "Protein", orElse: () => Nutrients(amount: 0, unit: "g"));
    final carbs = nutrients.firstWhere((n) => n.name == "Carbohydrates", orElse: () => Nutrients(amount: 0, unit: "g"));
    final fat = nutrients.firstWhere((n) => n.name == "Fat", orElse: () => Nutrients(amount: 0, unit: "g"));
    return Container(
      padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.06),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: "Nutritional Prediction", 
                    fontSize: DimensText.bodyText(context),
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold
                  ),
                  customText(
                    text: "ML ANALYZED ANALYSIS",
                    fontSize: DimensText.microText(context),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary
                  ),
                ],
              ),
              Icon(
                Icons.info_outline,
                size: RecipeMateAppUtil.screenWidth * 0.05,
                color: Theme.of(context).colorScheme.onSecondary
              ),
            ],
          ),
          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: RecipeMateAppUtil.screenWidth * 0.25,
                    height: RecipeMateAppUtil.screenWidth * 0.25,
                    child: CircularProgressIndicator(
                      value: kcalPercent,
                      strokeWidth: RecipeMateAppUtil.screenWidth * 0.025,
                      backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Column(
                    children: [
                      customText(
                        text: kcal?.toInt().toString() ?? "0",
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: DimensText.bodyText(context), 
                        fontWeight: FontWeight.bold
                      ),
                      customText(
                        text: "CALORIES", 
                        fontSize: DimensText.microText(context), 
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNutrientRow(context, "PROTEIN", "${protein.amount?.toInt()}${protein.unit}", "High", Theme.of(context).colorScheme.primary),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
                  _buildNutrientRow(context, "CARBS", "${carbs.amount?.toInt()}${carbs.unit}", "Normal", Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
                  _buildNutrientRow(context, "FATS", "${fat.amount?.toInt()}${fat.unit}", "Healthy", Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(BuildContext context, String label, String value, String status, Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: label, 
          fontSize: DimensText.microText(context), 
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: FontWeight.bold
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
              text: value,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: DimensText.bodyText(context), 
              fontWeight: FontWeight.bold
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.1),
            customText(
              text: status, 
              fontSize: DimensText.microText(context), 
              color: statusColor, 
              fontWeight: FontWeight.bold
            ),
          ],
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
      ],
    );
  }

  Widget _buildIngredientsSection(BuildContext context, List<ExtendedIngredients> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: "Core Ingredients",
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: DimensText.bodyText(context), 
          fontWeight: FontWeight.bold
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
        SizedBox(
          height: RecipeMateAppUtil.screenHeight * 0.16,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ingredients.length,
            separatorBuilder: (_, _) => SizedBox(width: RecipeMateAppUtil.screenWidth * 0.04),
            itemBuilder: (context, index) {
              final item = ingredients[index];
              final double size = RecipeMateAppUtil.screenWidth * 0.18;
              final String fullImageUrl = "https://spoonacular.com/cdn/ingredients_100x100/${item.image}";
              return Column(
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).cardColor, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(fullImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.01),
                  SizedBox(
                    width: size,
                    child: customText(
                      text: item.name ?? "",
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: DimensText.microText(context),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}