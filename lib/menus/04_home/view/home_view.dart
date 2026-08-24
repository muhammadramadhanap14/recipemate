import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
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
      child: Material(
        color: Colors.transparent,
        child: GlassScaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          edgeToEdge: true,
          extendBody: true,
          edgeFade: false,
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
          GlassIconButton(
            onPressed: () => Get.toNamed('/notification'),
            size: RecipeMateAppUtil.screenWidth * 0.12,
            iconSize: RecipeMateAppUtil.screenWidth * 0.07,
            icon: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.primary,
            ),
            settings: const LiquidGlassSettings(
              glassColor: Colors.transparent,
              thickness: 60,
              blur: 3,
              chromaticAberration: 0.3,
              lightIntensity: 0.6,
              refractiveIndex: 1.59,
              saturation: 1.0,
              ambientStrength: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, HomeViewModel viewModel) {
    return GlassTextField.search(
      controller: viewModel.searchController,
      focusNode: viewModel.searchFocusNode,
      placeholder: AppLocalizations.of(context)!.stSearchRecipes,
      onSubmitted: (value) => viewModel.searchRecipes(value),
      onChanged: (value) {
        if (value.isEmpty) {
          viewModel.searchResults.clear();
          viewModel.autoCompleteResults.clear();
        }
      },
      height: RecipeMateAppUtil.screenHeight * 0.07,
      prefixIcon: Icon(
        Icons.search,
        color: Theme.of(context).colorScheme.primary,
        size: RecipeMateAppUtil.screenWidth * 0.06,
      ),
      suffixIcon: Obx(() {
        if (viewModel.searchText.value.isEmpty) {
          return const SizedBox.shrink();
        }
        return Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.primary,
          size: RecipeMateAppUtil.screenWidth * 0.05,
        );
      }),
      onSuffixTap: () => viewModel.resetSearch(),
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: DimensText.bodyText(context),
        fontFamily: 'Poppins-Regular',
      ),
      placeholderStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        fontSize: DimensText.captionText(context),
        fontFamily: 'Poppins-Regular',
      ),
      settings: const LiquidGlassSettings(
        glassColor: Colors.transparent,
        thickness: 60,
        blur: 3,
        chromaticAberration: 0.3,
        lightIntensity: 0.6,
        refractiveIndex: 1.59,
        saturation: 1.0,
        ambientStrength: 1,
      ),
    );
  }

  // JANGAN DIHAPUS, INI AUTOCOMPLETE
  Widget _buildAutoCompleteList(BuildContext context, HomeViewModel viewModel) {
    return Obx(() {
      if (viewModel.autoCompleteResults.isEmpty) {
        return const SizedBox();
      }
      return Padding(
        padding: EdgeInsets.only(top: RecipeMateAppUtil.screenHeight * 0.01),
        child: GlassCard(
          padding: EdgeInsets.zero,
          shape: LiquidRoundedRectangle(borderRadius: 16),
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
                text: AppLocalizations.of(context)!.stRecommended,
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
                  text: AppLocalizations.of(context)!.stSeeAll,
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
        'color': const Color(0xFFE8F5E9),
      },
      {
        'name': 'Pasta',
        'icon': Icons.restaurant_rounded,
        'color': const Color(0xFFEDE7F6),
      },
      {
        'name': 'Pizza',
        'icon': Icons.local_pizza_rounded,
        'color': const Color(0xFFFFF3E0),
      },
      {
        'name': 'Burger',
        'icon': Icons.lunch_dining_rounded,
        'color': const Color(0xFFFFF8E1),
      },
      {
        'name': 'Steak',
        'icon': Icons.local_fire_department_rounded,
        'color': const Color(0xFFFFEBEE),
      },
      {
        'name': 'Dessert',
        'icon': Icons.icecream_rounded,
        'color': const Color(0xFFFCE4EC),
      },
      {
        'name': 'Sushi',
        'icon': Icons.set_meal_rounded,
        'color': const Color(0xFFE0F2F1),
      },
      {
        'name': 'Tacos',
        'icon': Icons.local_activity_rounded,
        'color': const Color(0xFFF1F8E9),
      },
      {
        'name': 'Drink',
        'icon': Icons.local_bar_rounded,
        'color': const Color(0xFFE1F5FE),
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
                text: AppLocalizations.of(context)!.stTopSearching,
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
                  text: AppLocalizations.of(context)!.stViewPopular,
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
                final Color baseColor = food['color'] as Color;
                final double size = RecipeMateAppUtil.screenWidth * 0.18;

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
                        GlassCard(
                          padding: EdgeInsets.zero,
                          width: size,
                          height: size,
                          shape: const LiquidOval(),
                          settings: LiquidGlassSettings(
                            glassColor: baseColor.withValues(alpha: 0.2),
                            thickness: 60,
                            blur: 3,
                            chromaticAberration: 0.3,
                            lightIntensity: 0.6,
                            refractiveIndex: 1.59,
                            saturation: 1.0,
                            ambientStrength: 1,
                          ),
                          child: Center(
                            child: Icon(
                              food['icon'] as IconData,
                              size: RecipeMateAppUtil.screenWidth * 0.09,
                              color: Theme.of(context).colorScheme.primary,
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
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
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

              // Bottom Glass Info Panel
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  shape: const LiquidRoundedRectangle(borderRadius: 0), // Flat bottom
                  settings: LiquidGlassSettings(
                    glassColor: Colors.black.withValues(alpha: 0.4),
                    thickness: 60,
                    blur: 3,
                    chromaticAberration: 0.3,
                    lightIntensity: 0.6,
                    refractiveIndex: 1.59,
                    saturation: 1.0,
                    ambientStrength: 1,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: title,
                        fontSize: DimensText.bodySmallText(context),
                        intMaxLine: 2,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (readyInMinutes != 0) ...[
                            const Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            customText(
                              text: "$readyInMinutes min",
                              fontSize: DimensText.captionText(context),
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (aggregateLikes != 0) ...[
                            const Icon(
                              Icons.favorite_rounded,
                              size: 14,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            customText(
                              text: "$aggregateLikes",
                              fontSize: DimensText.captionText(context),
                              color: Colors.white70,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}