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

    final primary = Theme.of(context).colorScheme.primary;

    return ConnectionWrapper(
      child: Material(
        color: Colors.transparent,
        child: GlassScaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          edgeToEdge: true,
          extendBody: true,
          edgeFade: false,
          background: Stack(
            children: [
              Container(color: Theme.of(context).scaffoldBackgroundColor),
              Positioned(
                top: -80,
                right: -80,
                child: buildBlurBlob(primary.withValues(alpha: 0.35), 420),
              ),
              Positioned(
                top: 380,
                left: -140,
                child: buildBlurBlob(primary.withValues(alpha: 0.22), 380),
              ),
              Positioned(
                bottom: 40,
                right: -120,
                child: buildBlurBlob(primary.withValues(alpha: 0.28), 400),
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await viewModel.getRecommendedRecipes();
                await viewModel.getDynamicFoodArticles();
              },
              color: primary,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                    _CategoryChips(viewModel: viewModel),
                    SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
                    _buildContent(context, viewModel),
                    SizedBox(height: RecipeMateAppUtil.screenHeight * 0.13),
                  ],
                ),
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
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                  width: 1.5,
                ),
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
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
            iconSize: RecipeMateAppUtil.screenWidth * 0.06,
            shape: GlassIconButtonShape.circle,
            icon: Icon(
              Icons.notifications_none_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            settings: LiquidGlassSettings(
              glassColor: Theme.of(context).cardColor,
              backerColor: Colors.black.withValues(alpha: 0.05),
              thickness: 70,
              blur: 6,
              chromaticAberration: 0.35,
              lightIntensity: 1.2,
              refractiveIndex: 1.65,
              ambientRim: 0.3,
              edgeAbsorption: 0.12,
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
        Icons.search_rounded,
        color: Theme.of(context).colorScheme.primary,
        size: RecipeMateAppUtil.screenWidth * 0.06,
      ),
      suffixIcon: Obx(() {
        if (viewModel.searchText.value.isEmpty) {
          return const SizedBox.shrink();
        }
        return Icon(
          Icons.close_rounded,
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
      settings: LiquidGlassSettings(
        glassColor: Theme.of(context).cardColor,
        backerColor: Colors.black.withValues(alpha: 0.05),
        thickness: 120,
        blur: 8,
        chromaticAberration: 0.4,
        lightIntensity: 1.25,
        refractiveIndex: 1.68,
        ambientRim: 0.3,
        edgeAbsorption: 0.12,
      ),
    );
  }

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
          settings: LiquidGlassSettings(
            glassColor: Theme.of(context).cardColor,
            backerColor: Colors.black.withValues(alpha: 0.05),
            thickness: 100,
            blur: 8,
            chromaticAberration: 0.4,
            lightIntensity: 1.2,
            refractiveIndex: 1.68,
            ambientRim: 0.3,
            edgeAbsorption: 0.12,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.autoCompleteResults.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            itemBuilder: (context, index) {
              final item = viewModel.autoCompleteResults[index];
              final String title = item['title'] ?? "";
              return InkWell(
                onTap: () {
                  viewModel.searchController.text = title;
                  viewModel.searchController.selection =
                      TextSelection.fromPosition(TextPosition(offset: title.length));
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
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
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
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
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
      return Column(
        children: [
          _buildRecommendedForYouSection(context, viewModel),
          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
          _buildFoodArticlesCarousel(context, viewModel),
        ],
      );
    });
  }

  Widget _buildFoodArticlesCarousel(BuildContext context, HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: RecipeMateAppUtil.screenWidth * 0.05,
          ),
          child: customText(
            text: AppLocalizations.of(context)!.stFoodArticles,
            fontSize: DimensText.headerMenusText(context),
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontFamily: 'times_new_roman_bold',
          ),
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
        Obx(() {
          if (viewModel.isLoadingArticles.value) {
            return SizedBox(
              height: RecipeMateAppUtil.screenHeight * 0.22,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.foodArticles.isEmpty) {
            return const SizedBox.shrink();
          }

          return SizedBox(
            height: RecipeMateAppUtil.screenHeight * 0.22,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.85),
              itemCount: viewModel.foodArticles.length,
              itemBuilder: (context, index) {
                final article = viewModel.foodArticles[index];
                final String title = article['title'] ?? "No Title";
                final String image = article['image'] ?? "";
                final String url = article['link'] ?? "";

                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      if (url.isNotEmpty) {
                        viewModel.launchBrowser(url);
                      }
                    },
                    child: GlassCard(
                      padding: EdgeInsets.zero,
                      shape: LiquidRoundedRectangle(
                        borderRadius: RecipeMateAppUtil.screenWidth * 0.05,
                      ),
                      settings: LiquidGlassSettings(
                        glassColor: Colors.white.withValues(alpha: 0.05),
                        backerColor: Colors.black.withValues(alpha: 0.1),
                        thickness: 100,
                        blur: 8,
                        chromaticAberration: 0.4,
                        lightIntensity: 1.2,
                        refractiveIndex: 1.68,
                        ambientRim: 0.3,
                        edgeAbsorption: 0.15,
                      ),
                      child: Stack(
                        children: [
                          if (image.isNotEmpty)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  RecipeMateAppUtil.screenWidth * 0.05,
                                ),
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(color: Colors.grey[900]),
                                ),
                              ),
                            ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  RecipeMateAppUtil.screenWidth * 0.05,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: customText(
                              text: title,
                              fontSize: DimensText.bodyText(context),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              intMaxLine: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSearchResultsSection(BuildContext context, HomeViewModel viewModel) {
    return Obx(() {
      if (viewModel.isSearching.value) {
        return SizedBox(
          height: RecipeMateAppUtil.screenHeight * 0.48,
          child: Center(
            child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
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
            padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
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
            padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.searchResults.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: RecipeMateAppUtil.screenWidth * 0.04,
                mainAxisSpacing: RecipeMateAppUtil.screenHeight * 0.02,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) => _buildRecommendedCard(
                context,
                viewModel.searchResults[index],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildRecommendedForYouSection(BuildContext context, HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
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
                onTap: () => Get.toNamed('/home_list', arguments: {'mode': 'recommended'}),
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
              padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
              child: SizedBox(
                height: RecipeMateAppUtil.screenHeight * 0.25,
                child: Center(
                  child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            );
          }

          final recipes = viewModel.recommendedRecipes.isNotEmpty
              ? viewModel.recommendedRecipes
              : [];

          if (recipes.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
              child: SizedBox(
                height: RecipeMateAppUtil.screenHeight * 0.25,
                child: Center(
                  child: customText(
                    text: "No recommended recipes available",
                    fontSize: DimensText.bodySmallText(context),
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: RecipeMateAppUtil.screenWidth * 0.04,
                mainAxisSpacing: RecipeMateAppUtil.screenHeight * 0.02,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) => _buildRecommendedCard(context, recipes[index]),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecommendedCard(BuildContext context, dynamic recipe) {
    final double borderRadius = RecipeMateAppUtil.screenWidth * 0.045;

    final String title = recipe is Map ? (recipe['title'] ?? "") : (recipe.title ?? "");
    final String image = recipe is Map ? (recipe['image'] ?? "") : (recipe.image ?? "");
    final dynamic id = recipe is Map ? (recipe['id'] ?? 0) : (recipe.id ?? 0);
    final dynamic readyInMinutes =
    recipe is Map ? (recipe['readyInMinutes'] ?? 0) : (recipe.readyInMinutes ?? 0);
    final dynamic aggregateLikes =
    recipe is Map ? (recipe['aggregateLikes'] ?? 0) : (recipe.aggregateLikes ?? 0);

    return GestureDetector(
      onTap: () => Get.toNamed('/home_detail', arguments: id),
      child: GlassCard(
        padding: EdgeInsets.zero,
        shape: LiquidRoundedRectangle(borderRadius: borderRadius),
        settings: LiquidGlassSettings(
          glassColor: Theme.of(context).cardColor,
          backerColor: Colors.black.withValues(alpha: 0.06),
          thickness: 100,
          blur: 8,
          chromaticAberration: 0.4,
          lightIntensity: 1.2,
          refractiveIndex: 1.68,
          ambientRim: 0.3,
          edgeAbsorption: 0.12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      text: title,
                      fontSize: DimensText.bodySmallText(context),
                      intMaxLine: 2,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        if (readyInMinutes != 0) ...[
                          Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 4),
                          customText(
                            text: "$readyInMinutes min",
                            fontSize: DimensText.captionText(context),
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 10),
                        ],
                        if (aggregateLikes != 0) ...[
                          Icon(
                            Icons.favorite_rounded,
                            size: 13,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          customText(
                            text: "$aggregateLikes",
                            fontSize: DimensText.captionText(context),
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
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
    );
  }
}

class _CategoryChips extends StatefulWidget {
  final HomeViewModel viewModel;
  const _CategoryChips({required this.viewModel});

  @override
  State<_CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<_CategoryChips> {
  int _selectedIndex = 0;

  static const List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.apps_rounded},
    {'label': 'Breakfast', 'icon': Icons.free_breakfast_rounded},
    {'label': 'Lunch', 'icon': Icons.lunch_dining_rounded},
    {'label': 'Dinner', 'icon': Icons.dinner_dining_rounded},
    {'label': 'Dessert', 'icon': Icons.icecream_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return SizedBox(
      height: RecipeMateAppUtil.screenHeight * 0.055,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.05),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final bool selected = index == _selectedIndex;
          final category = _categories[index];

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = index);
                if (index == 0) {
                  widget.viewModel.resetSearch();
                } else {
                  widget.viewModel.searchController.text = category['label'] as String;
                  widget.viewModel.searchRecipes(category['label'] as String);
                }
              },
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: LiquidRoundedRectangle(borderRadius: 30),
                settings: LiquidGlassSettings(
                  glassColor: selected
                      ? primary.withValues(alpha: 0.9)
                      : Theme.of(context).cardColor,
                  backerColor: Colors.black.withValues(alpha: selected ? 0.02 : 0.06),
                  thickness: 90,
                  blur: 7,
                  chromaticAberration: selected ? 0.15 : 0.4,
                  lightIntensity: 1.2,
                  refractiveIndex: 1.65,
                  ambientRim: 0.3,
                  edgeAbsorption: 0.12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      size: 16,
                      color: selected ? Theme.of(context).colorScheme.onPrimary : onSurface,
                    ),
                    const SizedBox(width: 6),
                    customText(
                      text: category['label'] as String,
                      fontSize: DimensText.captionText(context),
                      fontWeight: FontWeight.w600,
                      color: selected ? Theme.of(context).colorScheme.onPrimary : onSurface,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}