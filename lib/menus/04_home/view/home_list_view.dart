import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final Map<String, dynamic> arguments = Get.arguments is Map<String, dynamic>
        ? Get.arguments as Map<String, dynamic>
        : {};
    final String mode = arguments['mode'] is String
        ? arguments['mode'] as String
        : 'recommended';

    final HomeListViewModel viewModel = Get.put(
      HomeListViewModel(apiRepository: Get.find<ApiRepository>(), mode: mode),
    );

    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    final title = mode == 'popular' ? 'Popular Recipes' : 'Recommended Recipes';
    final subtitle = mode == 'popular'
        ? 'Browse popular categories or pick a recipe below.'
        : 'Explore more recipes randomly selected for you.';

    return ConnectionWrapper(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.chevron_left,
              color: Theme.of(context).colorScheme.onSurface,
              size: RecipeMateAppUtil.screenWidth * 0.08,
            ),
          ),
          title: customText(
            text: title,
            fontSize: DimensText.subHeaderLargeText(context),
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: false,
        ),
        body: Obx(() {
          if (viewModel.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: RecipeMateAppUtil.screenWidth * 0.05,
                vertical: RecipeMateAppUtil.screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: subtitle,
                    fontSize: DimensText.bodySmallText(context),
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
                  if (mode == 'popular')
                    _buildCategorySection(context, viewModel),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
                  _buildRecipeGrid(context, viewModel),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    HomeListViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: 'Browse by category',
          fontSize: DimensText.bodySmallText(context),
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
        SizedBox(
          height: RecipeMateAppUtil.screenHeight * 0.07,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.popularCategories.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: RecipeMateAppUtil.screenWidth * 0.03),
            itemBuilder: (context, index) {
              final category = viewModel.popularCategories[index];
              final bool isSelected =
                  viewModel.selectedCategory.value == category;
              return GestureDetector(
                onTap: () => viewModel.searchByCategory(category),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: RecipeMateAppUtil.screenWidth * 0.05,
                    vertical: RecipeMateAppUtil.screenHeight * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(
                        alpha: isSelected ? 0.0 : 0.12,
                      ),
                    ),
                  ),
                  child: customText(
                    text: category,
                    fontSize: DimensText.captionText(context),
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
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
        child: const Center(child: NoDataUtil()),
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
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final recipe = viewModel.recipes[index];
        return _buildRecipeCard(context, recipe);
      },
    );
  }

  Widget _buildRecipeCard(BuildContext context, dynamic recipe) {
    final double borderRadius = RecipeMateAppUtil.screenWidth * 0.04;
    final String title = recipe is Map
        ? (recipe['title'] ?? '')
        : (recipe is Results ? (recipe.title ?? '') : '');
    final String image = recipe is Map
        ? (recipe['image'] ?? '')
        : (recipe is Results ? (recipe.image ?? '') : '');
    final dynamic id = recipe is Map
        ? (recipe['id'] ?? 0)
        : (recipe is Results ? (recipe.id ?? 0) : 0);
    final dynamic readyInMinutes = recipe is Map
        ? (recipe['readyInMinutes'] ?? 0)
        : (recipe is Results ? (recipe.readyInMinutes ?? 0) : 0);
    final dynamic aggregateLikes = recipe is Map
        ? (recipe['aggregateLikes'] ?? 0)
        : (recipe is Results ? (recipe.aggregateLikes ?? 0) : 0);

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
                            text: '$readyInMinutes min',
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
                            text: '$aggregateLikes',
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
