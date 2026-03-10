import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/home_detail_view_model.dart';

class HomeDetailView extends StatelessWidget {
  const HomeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeDetailViewModel viewModel = Get.put(HomeDetailViewModel());
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    final recipe = viewModel.recipeDetail;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageHeader(context, recipe['image']),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),

                  _buildTitleSection(context, recipe),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),

                  _buildNutritionalCard(context, recipe),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),

                  _buildSmartMatchSection(context, recipe),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.04),

                  _buildIngredientsSection(context, recipe['ingredients']),
                ],
              ),
            ),
          ],
        ),
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
                  iconColor: Theme.of(context).colorScheme.onTertiary,
                  icon: Icons.keyboard_arrow_left,
                ),
                _buildCircleButton(
                  context: context,
                  onTap: () {},
                  icon: Icons.favorite,
                  iconColor: Theme.of(context).colorScheme.primary,
                ),
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

  Widget _buildTitleSection(BuildContext context, Map<String, dynamic> recipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: recipe['title'],
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
              text: recipe['time'], 
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
              text: "${recipe['rating']} (${recipe['reviews']})",
              fontSize: DimensText.captionText(context),
              color: Theme.of(context).colorScheme.onSurface
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionalCard(BuildContext context, Map<String, dynamic> recipe) {
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
                      value: 0.75,
                      strokeWidth: RecipeMateAppUtil.screenWidth * 0.025,
                      backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Column(
                    children: [
                      customText(
                        text: recipe['calories'].toString(),
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
                  _buildNutrientRow(context, "PROTEIN", recipe['protein'], "High", Theme.of(context).colorScheme.primary),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
                  _buildNutrientRow(context, "CARBS", recipe['carbs'], "Normal", Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
                  _buildNutrientRow(context, "FATS", recipe['fats'], "Healthy", Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
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
      ],
    );
  }

  Widget _buildSmartMatchSection(BuildContext context, Map<String, dynamic> recipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              size: RecipeMateAppUtil.screenWidth * 0.05,
              color: Theme.of(context).colorScheme.primary
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.02),
            customText(
              text: "Smart Match",
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: DimensText.bodyText(context),
              fontWeight: FontWeight.bold
            ),
          ],
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
        Container(
          padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.04),
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: DimensText.captionText(context),
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: "This recipe is a ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: DimensText.captionText(context)
                  ),
                ),
                TextSpan(
                  text: "${recipe['match_percent']}% match",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: DimensText.captionText(context),
                    fontWeight: FontWeight.bold
                  ),
                ),
                TextSpan(
                  text: " for your goal of ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: DimensText.captionText(context)
                  ),
                ),
                TextSpan(
                  text: "increasing lean muscle mass. ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: DimensText.captionText(context)
                  ),
                ),
                TextSpan(
                  text: recipe['match_reason'].toString().split("mass. ").last,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: DimensText.captionText(context)
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(BuildContext context, List<dynamic> ingredients) {
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
              return Column(
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).cardColor, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(item['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.01),
                  customText(
                    text: item['name'],
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: DimensText.microText(context),
                    fontWeight: FontWeight.bold
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