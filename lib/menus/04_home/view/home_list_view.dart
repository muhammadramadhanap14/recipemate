import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/repository/api_repository.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/dimens_text.dart';
import 'package:recipemate/utils/view_utils/no_data_util.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';
import 'package:recipemate/models/model_response/search_recipes_response.dart';
import 'home_list_view_model.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
    Get.arguments is Map<String, dynamic> ? Get.arguments as Map<String, dynamic> : {};
    final String mode = arguments['mode'] is String ? arguments['mode'] as String : 'recommended';

    final HomeListViewModel viewModel = Get.put(
      HomeListViewModel(
        apiRepository: Get.find<ApiRepository>(),
        mode: mode,
      ),
    );

    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    final primary = Theme.of(context).colorScheme.primary;
    final title = mode == 'popular' ? AppLocalizations.of(context)!.stPopularRecipes : AppLocalizations.of(context)!.stRecommendedRecipes;
    final subtitle = mode == 'popular' ? AppLocalizations.of(context)!.stBrowseByCategoryMsg : AppLocalizations.of(context)!.stPopularRecipesMsg;

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
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              Positioned(
                top: -80,
                right: -80,
                child: buildBlurBlob(
                  primary.withValues(alpha: 0.35),
                  420,
                ),
              ),
              Positioned(
                top: 380,
                left: -140,
                child: buildBlurBlob(
                  primary.withValues(alpha: 0.22),
                  380,
                ),
              ),
              Positioned(
                bottom: 40,
                right: -120,
                child: buildBlurBlob(
                  primary.withValues(alpha: 0.28),
                  400,
                ),
              ),
            ],
          ),
          appBar: GlassAppBar(
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: EdgeInsets.only(
                left: RecipeMateAppUtil.screenWidth * 0.03,
              ),
              child: GlassIconButton(
                onPressed: () => Get.back(),
                size: RecipeMateAppUtil.screenWidth * 0.11,
                iconSize: RecipeMateAppUtil.screenWidth * 0.06,
                shape: GlassIconButtonShape.circle,
                icon: Icon(
                  Icons.keyboard_arrow_left_rounded,
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
            ),
            title: customText(
              text: title,
              fontSize: DimensText.headerMenusText(context),
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontFamily: 'times_new_roman_bold',
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Obx(() {
                if (viewModel.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: primary,
                    ),
                  );
                }

                final double topReserved = MediaQuery.of(context).padding.top + 10.0;

                return RefreshIndicator(
                  color: primary,
                  backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainer,
                  onRefresh: () async {
                    if (mode == 'popular') {
                      final category =
                          viewModel.selectedCategory.value;

                      if (category.isNotEmpty) {
                        await viewModel.searchByCategory(category);
                      }
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: RecipeMateAppUtil.screenWidth * 0.05,
                        vertical: RecipeMateAppUtil.screenHeight * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: topReserved),
                          customText(
                            text: subtitle,
                            fontSize:
                            DimensText.bodySmallText(context),
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(
                              alpha: 0.65,
                            ),
                            intMaxLine: null,
                          ),
                          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.025),
                          if (mode == 'popular') _buildCategorySection(context, viewModel),
                          if (mode == 'popular') SizedBox(height: RecipeMateAppUtil.screenHeight * 0.025),
                          _buildRecipeGrid(context, viewModel),
                          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.04),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, HomeListViewModel viewModel) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: AppLocalizations.of(context)!.stBrowseByCategory,
          fontSize: DimensText.bodySmallText(context),
          color: onSurface,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
        SizedBox(
          height: RecipeMateAppUtil.screenHeight * 0.055,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.popularCategories.length,
            separatorBuilder: (context, index) => SizedBox(width: RecipeMateAppUtil.screenWidth * 0.03),
            itemBuilder: (context, index) {
              final category = viewModel.popularCategories[index];
              final bool isSelected = viewModel.selectedCategory.value == category;
              return GestureDetector(
                onTap: () => viewModel.searchByCategory(category),
                child: GlassCard(
                  padding: EdgeInsets.symmetric(
                    horizontal: RecipeMateAppUtil.screenWidth * 0.05,
                    vertical: RecipeMateAppUtil.screenHeight * 0.006,
                  ),
                  shape: LiquidRoundedRectangle(borderRadius: 30),
                  settings: LiquidGlassSettings(
                    glassColor: isSelected ? primary.withValues(alpha: 0.9) : Theme.of(context).cardColor,
                    backerColor: Colors.black.withValues(alpha: isSelected ? 0.02 : 0.06),
                    thickness: 90,
                    blur: 7,
                    chromaticAberration: isSelected ? 0.15 : 0.4,
                    lightIntensity: 1.2,
                    refractiveIndex: 1.65,
                    ambientRim: 0.3,
                    edgeAbsorption: 0.12,
                  ),
                  child: Center(
                    child: customText(
                      text: category,
                      fontSize: DimensText.captionText(context),
                      color: isSelected ? Theme.of(context,).colorScheme.onPrimary : onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeGrid(BuildContext context, HomeListViewModel viewModel) {
    if (viewModel.isSearching.value) {
      return SizedBox(
        height: RecipeMateAppUtil.screenHeight * 0.4,
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (viewModel.recipes.isEmpty) {
      return SizedBox(
        height: RecipeMateAppUtil.screenHeight * 0.4,
        child: const Center(
          child: NoDataUtil(),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.recipes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: RecipeMateAppUtil.screenWidth * 0.04,
        mainAxisSpacing: RecipeMateAppUtil.screenHeight * 0.02,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final recipe = viewModel.recipes[index];
        return _buildRecipeCard(
          context,
          recipe,
        );
      },
    );
  }

  Widget _buildRecipeCard(BuildContext context, dynamic recipe) {
    final double borderRadius = RecipeMateAppUtil.screenWidth * 0.045;
    final String title = recipe is Map ? (recipe['title'] ?? '') : (recipe is Results ? (recipe.title ?? '') : '');
    final String image = recipe is Map ? (recipe['image'] ?? '') : (recipe is Results ? (recipe.image ?? '') : '');
    final dynamic id = recipe is Map ? (recipe['id'] ?? 0) : (recipe is Results ? (recipe.id ?? 0) : 0);
    final dynamic readyInMinutes = recipe is Map ? (recipe['readyInMinutes'] ?? 0) : (recipe is Results ? (recipe.readyInMinutes ?? 0) : 0);
    final dynamic aggregateLikes = recipe is Map ? (recipe['aggregateLikes'] ?? 0) : (recipe is Results ? (recipe.aggregateLikes ?? 0) : 0);

    return GestureDetector(
      onTap: () => Get.toNamed(
        '/home_detail',
        arguments: id,
      ),

      child: GlassCard(
        padding: EdgeInsets.zero,
        shape: LiquidRoundedRectangle(
          borderRadius: borderRadius,
        ),
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
                  topLeft: Radius.circular(
                    borderRadius,
                  ),
                  topRight: Radius.circular(
                    borderRadius,
                  ),
                ),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                    Container(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
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
                            text: '$readyInMinutes min',
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
                            text: '$aggregateLikes',
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