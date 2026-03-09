import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/color_var.dart';
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
      backgroundColor: HexColor(ColorVar.bgAppColor),
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
                  onTap: () => Get.back(),
                  icon: Icons.chevron_left,
                ),
                _buildCircleButton(
                  onTap: () {},
                  icon: Icons.favorite,
                  iconColor: HexColor(ColorVar.redStatus),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({required VoidCallback onTap, required IconData icon, Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.02),
        decoration: BoxDecoration(
          color: HexColor(ColorVar.white),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? HexColor(ColorVar.black),
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
          fontSize: DimensText.headerText(context),
          fontWeight: FontWeight.bold,
          fontFamily: 'times_new_roman_bold',
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
        Row(
          children: [
            Icon(
              Icons.access_time_filled, 
              color: HexColor(ColorVar.appColor), 
              size: RecipeMateAppUtil.screenWidth * 0.05
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.015),
            customText(
              text: recipe['time'], 
              fontSize: DimensText.captionText(context), 
              color: HexColor(ColorVar.bgGray8)
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.04),
            Icon(
              Icons.star, 
              color: HexColor(ColorVar.orangeStatus), 
              size: RecipeMateAppUtil.screenWidth * 0.05
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.015),
            customText(
              text: "${recipe['rating']} (${recipe['reviews']})",
              fontSize: DimensText.captionText(context),
              color: HexColor(ColorVar.bgGray8),
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
        color: HexColor(ColorVar.bgGrayDataTable),
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
                    fontWeight: FontWeight.bold
                  ),
                  customText(
                    text: "ML ANALYZED ANALYSIS",
                    fontSize: DimensText.microText(context),
                    fontWeight: FontWeight.bold,
                    color: HexColor(ColorVar.appColor).withValues(alpha: 0.6),
                  ),
                ],
              ),
              Icon(
                Icons.info_outline,
                size: RecipeMateAppUtil.screenWidth * 0.05,
                color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.4)
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
                      backgroundColor: HexColor(ColorVar.bgGray8).withValues(alpha: 0.1),
                      color: HexColor(ColorVar.appColor),
                    ),
                  ),
                  Column(
                    children: [
                      customText(
                        text: recipe['calories'].toString(), 
                        fontSize: DimensText.bodyText(context), 
                        fontWeight: FontWeight.bold
                      ),
                      customText(
                        text: "CALORIES", 
                        fontSize: DimensText.microText(context), 
                        color: HexColor(ColorVar.bgGray8)
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNutrientRow(context, "PROTEIN", recipe['protein'], "High", HexColor(ColorVar.redStatus)),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
                  _buildNutrientRow(context, "CARBS", recipe['carbs'], "Normal", HexColor(ColorVar.bgGray8)),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
                  _buildNutrientRow(context, "FATS", recipe['fats'], "Healthy", HexColor(ColorVar.bgGray8)),
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
          color: HexColor(ColorVar.bgGray8), 
          fontWeight: FontWeight.bold
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
              text: value, 
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
              color: HexColor(ColorVar.appColor)
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.02),
            customText(
              text: "Smart Match", 
              fontSize: DimensText.bodyText(context), 
              fontWeight: FontWeight.bold
            ),
          ],
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
        Container(
          padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.04),
          decoration: BoxDecoration(
            color: HexColor(ColorVar.white),
            borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.04),
            border: Border.all(color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: HexColor(ColorVar.black).withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: HexColor(ColorVar.bgGray8),
                fontSize: DimensText.captionText(context),
                height: 1.5,
              ),
              children: [
                const TextSpan(text: "This recipe is a "),
                TextSpan(
                  text: "${recipe['match_percent']}% match",
                  style: TextStyle(color: HexColor(ColorVar.appColor), fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: " for your goal of "),
                TextSpan(
                  text: "increasing lean muscle mass. ", 
                  style: TextStyle(fontWeight: FontWeight.bold, color: HexColor(ColorVar.black))
                ),
                TextSpan(text: recipe['match_reason'].toString().split("mass. ").last),
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
                      border: Border.all(color: HexColor(ColorVar.bgGrayDataTable), width: 2),
                      image: DecorationImage(
                        image: NetworkImage(item['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.01),
                  customText(
                    text: item['name'], 
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