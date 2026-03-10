import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/recipemate_app_util.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: RecipeMateAppUtil.screenWidth * 0.005,
              ),
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
                  color: Theme.of(context).colorScheme.primary
                ),
                Obx(() => customText(
                  text: viewModel.userName.value,
                  fontSize: DimensText.headerMenusText(context),
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'times_new_roman_bold',
                )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.025),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.primary,
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.04),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
            size: RecipeMateAppUtil.screenWidth * 0.06,
          ),
          SizedBox(width: RecipeMateAppUtil.screenWidth * 0.03),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search recipes, ingredients...",
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: DimensText.captionText(context),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(
            Icons.mic,
            color: Theme.of(context).colorScheme.primary,
            size: RecipeMateAppUtil.screenWidth * 0.06,
          ),
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
            color: Theme.of(context).colorScheme.onSurface,
          ),
          customText(
            text: actionText,
            fontSize: DimensText.captionText(context),
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedList(BuildContext context, HomeViewModel viewModel) {
    return SizedBox(
      height: RecipeMateAppUtil.screenHeight * 0.41,
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

    return GestureDetector(
      onTap: () => Get.toNamed('/home_detail'),
      child: SizedBox(
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
                    height: RecipeMateAppUtil.screenHeight * 0.32,
                    width: cardWidth,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: RecipeMateAppUtil.screenHeight * 0.015,
                  left: RecipeMateAppUtil.screenWidth * 0.03,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: RecipeMateAppUtil.screenWidth * 0.025,
                      vertical: RecipeMateAppUtil.screenHeight * 0.008,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.05),
                    ),
                    child: customText(
                      text: "${recipe['match']}% MATCH",
                      fontSize: DimensText.captionText(context),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                Positioned(
                  top: RecipeMateAppUtil.screenHeight * 0.015,
                  right: RecipeMateAppUtil.screenWidth * 0.03,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5),
                    radius: RecipeMateAppUtil.screenWidth * 0.045,
                    child: Icon(
                      Icons.favorite,
                      size: RecipeMateAppUtil.screenWidth * 0.045,
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            customText(
              text: recipe['subtitle'],
              fontSize: DimensText.captionText(context),
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBadge(BuildContext context, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: RecipeMateAppUtil.screenWidth * 0.02,
        vertical: RecipeMateAppUtil.screenHeight * 0.005,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.03),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: RecipeMateAppUtil.screenWidth * 0.03,
          ),
          SizedBox(width: RecipeMateAppUtil.screenWidth * 0.01),
          customText(
            text: text,
            fontSize: DimensText.captionText(context),
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
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
          return GestureDetector(
            onTap: () => Get.toNamed('/home_detail'),
            child: Column(
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      width: RecipeMateAppUtil.screenWidth * 0.005,
                    ),
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
                  fontSize: DimensText.captionText(context),
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}