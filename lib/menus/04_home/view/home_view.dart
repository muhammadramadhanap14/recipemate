import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/color_var.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.put(HomeViewModel());
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    return Scaffold(
      backgroundColor: HexColor(ColorVar.bgAppColor),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
              _buildHeader(context, viewModel),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
                child: _buildSearchBar(context),
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),

              _buildSectionHeader(context, "Recommended for You", "See all"),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.01),
              _buildRecommendedList(context, viewModel),

              _buildSectionHeader(context, "Top Searching Food", "View Popular"),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.01),
              _buildTopSearchingList(context, viewModel),

              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
      child: Row(
        children: [
          Container(
            width: RecipeMateAppUtil.screenWidth * 0.13,
            height: RecipeMateAppUtil.screenWidth * 0.13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: HexColor(ColorVar.appColor), width: 2),
              image: const DecorationImage(
                image: AssetImage("assets/images/profile_pict_icon.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: RecipeMateAppUtil.screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: "GOOD MORNING",
                  fontSize: DimensText.microText(context),
                  fontWeight: FontWeight.bold,
                  color: HexColor(ColorVar.appColor).withValues(alpha: 0.6),
                ),
                Obx(() => customText(
                  text: viewModel.userName.value,
                  fontSize: DimensText.headerMenusText(context),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'times_new_roman_bold',
                )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.025),
            decoration: BoxDecoration(
              color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications,
              color: HexColor(ColorVar.appColor).withValues(alpha: 0.6),
              size: RecipeMateAppUtil.screenWidth * 0.07,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: RecipeMateAppUtil.screenHeight * 0.07,
      padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.04),
      decoration: BoxDecoration(
        color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.04),
        border: Border.all(color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: HexColor(ColorVar.appColor), size: RecipeMateAppUtil.screenWidth * 0.06),
          SizedBox(width: RecipeMateAppUtil.screenWidth * 0.03),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search recipes, ingredients...",
                hintStyle: TextStyle(
                  color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.4),
                  fontSize: DimensText.captionText(context),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.mic, color: HexColor(ColorVar.appColor), size: RecipeMateAppUtil.screenWidth * 0.06),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String actionText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(
            text: title,
            fontSize: DimensText.subHeaderText(context),
            fontWeight: FontWeight.bold,
            fontFamily: 'times_new_roman_bold',
          ),
          customText(
            text: actionText,
            fontSize: DimensText.captionText(context),
            color: HexColor(ColorVar.appColor),
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedList(BuildContext context, HomeViewModel viewModel) {
    return SizedBox(
      height: RecipeMateAppUtil.screenHeight * 0.40,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.recommendedRecipes.length,
        separatorBuilder: (_, _) => SizedBox(width: RecipeMateAppUtil.screenWidth * 0.05),
        itemBuilder: (context, index) {
          final recipe = viewModel.recommendedRecipes[index];
          return _buildRecommendedCard(context, recipe);
        },
      ),
    );
  }

  Widget _buildRecommendedCard(BuildContext context, Map<String, dynamic> recipe) {
    final double cardWidth = RecipeMateAppUtil.screenWidth * 0.65;
    final double borderRadius = RecipeMateAppUtil.screenWidth * 0.08;

    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Image.network(
                  recipe['image'],
                  height: RecipeMateAppUtil.screenHeight * 0.30,
                  width: cardWidth,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: RecipeMateAppUtil.screenHeight * 0.015,
                left: RecipeMateAppUtil.screenWidth * 0.03,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: HexColor(ColorVar.appColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: customText(
                    text: "${recipe['match']}% MATCH",
                    fontSize: DimensText.microText(context),
                    fontWeight: FontWeight.bold,
                    color: HexColor(ColorVar.white),
                  ),
                ),
              ),
              Positioned(
                top: RecipeMateAppUtil.screenHeight * 0.015,
                right: RecipeMateAppUtil.screenWidth * 0.03,
                child: CircleAvatar(
                  backgroundColor: HexColor(ColorVar.white),
                  radius: 18,
                  child: Icon(Icons.favorite, color: HexColor(ColorVar.red), size: 18),
                ),
              ),
              Positioned(
                bottom: RecipeMateAppUtil.screenHeight * 0.015,
                left: RecipeMateAppUtil.screenWidth * 0.03,
                right: RecipeMateAppUtil.screenWidth * 0.03,
                child: Row(
                  children: [
                    _buildCardBadge(context, Icons.access_time, recipe['time']),
                    SizedBox(width: RecipeMateAppUtil.screenWidth * 0.02),
                    _buildCardBadge(context, Icons.star, recipe['rating'].toString()),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
          customText(
            text: recipe['title'],
            fontSize: DimensText.bodyText(context),
            fontWeight: FontWeight.bold,
          ),
          customText(
            text: recipe['subtitle'],
            fontSize: DimensText.captionText(context),
            color: HexColor(ColorVar.appColor).withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildCardBadge(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: HexColor(ColorVar.black).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: HexColor(ColorVar.appColor), size: 12),
          SizedBox(width: RecipeMateAppUtil.screenWidth * 0.01),
          customText(
            text: text,
            fontSize: DimensText.captionText(context),
            color: HexColor(ColorVar.white),
            fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildTopSearchingList(BuildContext context, HomeViewModel viewModel) {
    return SizedBox(
      height: RecipeMateAppUtil.screenHeight * 0.16,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.topSearching.length,
        separatorBuilder: (_, _) => SizedBox(width: RecipeMateAppUtil.screenWidth * 0.05),
        itemBuilder: (context, index) {
          final item = viewModel.topSearching[index];
          final double avatarSize = RecipeMateAppUtil.screenWidth * 0.2;
          return Column(
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: HexColor(ColorVar.appColor).withValues(alpha: 0.1), width: 2),
                  image: DecorationImage(
                    image: NetworkImage(item['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.01),
              customText(
                text: item['name'],
                fontSize: DimensText.captionText(context),
                fontWeight: FontWeight.bold,
              ),
            ],
          );
        },
      ),
    );
  }
}