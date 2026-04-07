import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/utils/view_utils/no_data_util.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/greeting_util.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../../../utils/view_utils/connection_wrapper.dart';
import '../view_model/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Get.put(
      HomeViewModel(
        apiRepository: Get.find<ApiRepository>(),
        session: Get.find<DataSessionUtilController>(),
      )
    );
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });
    return ConnectionWrapper(
      child: Scaffold(
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
                  child: _buildSearchBar(context, viewModel),
                ),
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
                _buildRecommendedList(context, viewModel),
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeViewModel viewModel) {
    final double avatarSize = RecipeMateAppUtil.screenWidth * 0.13;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
      child: Row(
        children: [
          Obx(() {
            return Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: viewModel.session.profileImage.value != null
                    ? FileImage(viewModel.session.profileImage.value!)
                    : const AssetImage("assets/images/profile_pict_icon.png") as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
          SizedBox(width: RecipeMateAppUtil.screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: GreetingUtil.getGreeting(context),
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
          // Container(
          //   padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.025),
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).cardColor,
          //     shape: BoxShape.circle,
          //   ),
          //   child: Icon(
          //     Icons.notifications,
          //     color: Theme.of(context).colorScheme.primary,
          //     size: RecipeMateAppUtil.screenWidth * 0.07,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, HomeViewModel viewModel) {
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
              onSubmitted: (value) => viewModel.searchRecipes(value),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.stSearchRecipes,
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: DimensText.captionText(context),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
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
          )
        ],
      ),
    );
  }

  Widget _buildRecommendedList(BuildContext context, HomeViewModel viewModel) {
    return Obx(() {
      if (viewModel.isSearching.value) {
        return SizedBox(
          height: RecipeMateAppUtil.screenHeight * 0.48,
          child: const Center(child: CircularProgressIndicator()),
        );
      }
      if (viewModel.searchResults.isEmpty) {
        return SizedBox(
          height: RecipeMateAppUtil.screenHeight * 0.48,
          child: const Center(child: NoDataUtil()),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, AppLocalizations.of(context)!.stRecommended),
          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.searchResults.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: RecipeMateAppUtil.screenWidth * 0.04,
                mainAxisSpacing: RecipeMateAppUtil.screenHeight * 0.02,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final recipe = viewModel.searchResults[index];
                return _buildRecommendedCard(context, recipe);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildRecommendedCard(BuildContext context, dynamic recipe) {
    final double borderRadius = RecipeMateAppUtil.screenWidth * 0.04;

    return GestureDetector(
      onTap: () => Get.toNamed('/home_detail', arguments: recipe.id),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  recipe.image ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.65),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: recipe.title ?? "",
                      fontSize: DimensText.captionText(context),
                      intMaxLine: null,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: RecipeMateAppUtil.screenHeight * 0.004),
                    Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: customText(
                          text: "ID Recipe: ${recipe.id}",
                          fontSize: DimensText.captionText(context),
                          intMaxLine: null,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}