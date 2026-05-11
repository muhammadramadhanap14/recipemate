import 'dart:ui';
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
      ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: RecipeMateAppUtil.screenWidth * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(context, viewModel),
                      _buildAutoCompleteList(context, viewModel),
                    ],
                  ),
                ),
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
                _buildContent(context, viewModel),
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
      padding: EdgeInsets.symmetric(
        horizontal: RecipeMateAppUtil.screenWidth * 0.05,
      ),
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
                      : const AssetImage("assets/images/profile_pict_icon.png")
                            as ImageProvider,
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
                  fontSize: DimensText.bodySmallText(context),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Obx(
                  () => customText(
                    text: viewModel.userName.value,
                    fontSize: DimensText.headerMenusText(context),
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'times_new_roman_bold',
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed('/notification');
            },
            child: Container(
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
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, HomeViewModel viewModel) {
    return Container(
      height: RecipeMateAppUtil.screenHeight * 0.07,
      padding: EdgeInsets.symmetric(
        horizontal: RecipeMateAppUtil.screenWidth * 0.04,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(
          RecipeMateAppUtil.screenWidth * 0.04,
        ),
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
              controller: viewModel.searchController,
              focusNode: viewModel.searchFocusNode,
              // // Uncomment kalau mau pakai autocomplete cuma boros token api nya, cepat kena daily limit
              // onChanged: (value) {
              //   viewModel.getAutoComplete(value);
              // },
              onSubmitted: (value) => viewModel.searchRecipes(value),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.stSearchRecipes,
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: DimensText.captionText(context),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Obx(() {
            if (viewModel.searchText.value.isEmpty) {
              return const SizedBox();
            }
            return GestureDetector(
              onTap: () => viewModel.resetSearch(),
              child: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.primary,
                size: RecipeMateAppUtil.screenWidth * 0.05,
              ),
            );
          }),
        ],
      ),
    );
  }

  // JANGAN DIHAPUS, INI AUTOCOMPLETE
  Widget _buildAutoCompleteList(BuildContext context, HomeViewModel viewModel) {
    return Obx(() {
      if (viewModel.autoCompleteResults.isEmpty) {
        return const SizedBox();
      }
      return Container(
        margin: EdgeInsets.only(top: RecipeMateAppUtil.screenHeight * 0.01),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.autoCompleteResults.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            itemBuilder: (context, index) {
              final item = viewModel.autoCompleteResults[index];
              final String title = item['title'] ?? "";
              return InkWell(
                onTap: () {
                  viewModel.searchController.text = title;
                  viewModel.searchController.selection =
                      TextSelection.fromPosition(
                        TextPosition(offset: title.length),
                      );
                  viewModel.searchRecipes(title);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: RecipeMateAppUtil.screenHeight * 0.015,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 18,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: customText(
                          text: title,
                          fontSize: DimensText.bodySmallText(context),
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.north_west_rounded,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildContent(BuildContext context, HomeViewModel viewModel) {
    return Obx(() {
      // If searching and have results, show search results
      if (viewModel.isSearching.value || viewModel.searchResults.isNotEmpty) {
        return _buildSearchResultsSection(context, viewModel);
      }
      // Default view: recommended + top searching food
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildRecommendedForYouSection(context, viewModel),
            SizedBox(height: RecipeMateAppUtil.screenHeight * 0.04),
            _buildTopSearchingFoodSection(context, viewModel),
          ],
        ),
      );
    });
  }

  Widget _buildSearchResultsSection(
    BuildContext context,
    HomeViewModel viewModel,
  ) {
    return Obx(() {
      if (viewModel.isSearching.value) {
        return SizedBox(
          height: RecipeMateAppUtil.screenHeight * 0.48,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: RecipeMateAppUtil.screenWidth * 0.05,
            ),
            child: customText(
              text: "Search Results",
              fontSize: DimensText.headerMenusText(context),
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontFamily: 'times_new_roman_bold',
            ),
          ),
          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: RecipeMateAppUtil.screenWidth * 0.05,
            ),
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

  Widget _buildRecommendedForYouSection(
    BuildContext context,
    HomeViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: RecipeMateAppUtil.screenWidth * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(
                text: "Recommended for You",
                fontSize: DimensText.headerMenusText(context),
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontFamily: 'times_new_roman_bold',
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/home_list', arguments: {'mode': 'recommended'});
                },
                child: customText(
                  text: "See all",
                  fontSize: DimensText.bodySmallText(context),
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
        Obx(() {
          if (viewModel.isLoadingRecommended.value) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: RecipeMateAppUtil.screenWidth * 0.05,
              ),
              child: SizedBox(
                height: RecipeMateAppUtil.screenHeight * 0.25,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            );
          }

          final recipes = viewModel.recommendedRecipes.isNotEmpty
              ? viewModel.recommendedRecipes
              : [];

          if (recipes.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: RecipeMateAppUtil.screenWidth * 0.05,
              ),
              child: SizedBox(
                height: RecipeMateAppUtil.screenHeight * 0.25,
                child: Center(
                  child: customText(
                    text: "No recommended recipes available",
                    fontSize: DimensText.bodySmallText(context),
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: RecipeMateAppUtil.screenWidth * 0.05,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: RecipeMateAppUtil.screenWidth * 0.04,
                mainAxisSpacing: RecipeMateAppUtil.screenHeight * 0.02,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return _buildRecommendedCard(context, recipe);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTopSearchingFoodSection(
    BuildContext context,
    HomeViewModel viewModel,
  ) {
    final topSearchingFoods = [
      {
        'name': 'Salad',
        'icon': Icons.eco_rounded,
        'color': const Color(0xFFFFF3E0),
      },
      {
        'name': 'Pasta',
        'icon': Icons.restaurant_rounded,
        'color': const Color(0xFFEDE7F6),
      },
      {
        'name': 'Steak',
        'icon': Icons.local_fire_department_rounded,
        'color': const Color(0xFFFFEBEE),
      },
      {
        'name': 'Tacos',
        'icon': Icons.lunch_dining_rounded,
        'color': const Color(0xFFE8F5E9),
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: RecipeMateAppUtil.screenWidth * 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(
                text: "Top Searching Food",
                fontSize: DimensText.headerMenusText(context),
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontFamily: 'times_new_roman_bold',
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/home_list', arguments: {'mode': 'popular'});
                },
                child: customText(
                  text: "View Popular",
                  fontSize: DimensText.bodySmallText(context),
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
          SizedBox(
            height: RecipeMateAppUtil.screenHeight * 0.16,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topSearchingFoods.length,
              itemBuilder: (context, index) {
                final food = topSearchingFoods[index];
                final bool isDark = Theme.of(context).brightness == Brightness.dark;
                final Color baseColor = food['color'] as Color;
                return Padding(
                  padding: EdgeInsets.only(
                    right: RecipeMateAppUtil.screenWidth * 0.04,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      viewModel.searchController.text = food['name'] as String;
                      viewModel.searchRecipes(food['name'] as String);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: RecipeMateAppUtil.screenWidth * 0.18,
                          height: RecipeMateAppUtil.screenWidth * 0.18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? baseColor.withValues(alpha: 0.15)
                                    : Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isDark
                                        ? [
                                            baseColor.withValues(alpha: 0.4),
                                            baseColor.withValues(alpha: 0.1),
                                          ]
                                        : [
                                            Colors.white.withValues(alpha: 0.7),
                                            baseColor.withValues(alpha: 0.8),
                                          ],
                                  ),
                                  border: Border.all(
                                    color: isDark
                                        ? baseColor.withValues(alpha: 0.25)
                                        : Colors.white.withValues(alpha: 0.5),
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    food['icon'] as IconData,
                                    size: RecipeMateAppUtil.screenWidth * 0.09,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.01),
                        customText(
                          text: food['name'] as String,
                          fontSize: DimensText.bodySmallText(context),
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedList(BuildContext context, HomeViewModel viewModel) {
    return Obx(() {
      if (viewModel.isSearching.value) {
        return SizedBox(
          height: RecipeMateAppUtil.screenHeight * 0.48,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: RecipeMateAppUtil.screenWidth * 0.05,
            ),
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

    // Handle both dynamic map and object
    final String title = recipe is Map
        ? (recipe['title'] ?? "")
        : (recipe.title ?? "");
    final String image = recipe is Map
        ? (recipe['image'] ?? "")
        : (recipe.image ?? "");
    final dynamic id = recipe is Map ? (recipe['id'] ?? 0) : (recipe.id ?? 0);
    final dynamic readyInMinutes = recipe is Map
        ? (recipe['readyInMinutes'] ?? 0)
        : (recipe.readyInMinutes ?? 0);
    final dynamic aggregateLikes = recipe is Map
        ? (recipe['aggregateLikes'] ?? 0)
        : (recipe.aggregateLikes ?? 0);

    return GestureDetector(
      onTap: () => Get.toNamed('/home_detail', arguments: id),
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
                  image,
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
                      text: title,
                      fontSize: DimensText.bodySmallText(context),
                      intMaxLine: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: RecipeMateAppUtil.screenHeight * 0.008),
                    Row(
                      children: [
                        if (readyInMinutes != 0) ...[
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          SizedBox(width: 4),
                          customText(
                            text: "$readyInMinutes min",
                            fontSize: DimensText.captionText(context),
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          SizedBox(width: 12),
                        ],
                        if (aggregateLikes != 0) ...[
                          Icon(
                            Icons.favorite_rounded,
                            size: 14,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          SizedBox(width: 4),
                          customText(
                            text: "$aggregateLikes",
                            fontSize: DimensText.captionText(context),
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ],
                      ],
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
