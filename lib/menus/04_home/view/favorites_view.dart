import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/menus/04_home/view_model/favorites_controller.dart';
import 'package:recipemate/utils/dimens_text.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import 'package:recipemate/utils/view_utils/app_snackbar.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  final FavoritesController _controller = Get.find<FavoritesController>();
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

  static LiquidGlassSettings _glassSettings(BuildContext context, {double backerAlpha = 0.06}) {
    return LiquidGlassSettings(
      glassColor: Theme.of(context).cardColor,
      backerColor: Colors.black.withValues(alpha: backerAlpha),
      thickness: 100,
      blur: 8,
      chromaticAberration: 0.4,
      lightIntensity: 1.2,
      refractiveIndex: 1.68,
      saturation: 1.1,
      ambientStrength: 1.1,
      ambientRim: 0.3,
      edgeAbsorption: 0.12,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RecipeMateAppUtil.init(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final double topReserved = MediaQuery.of(context).padding.top + kToolbarHeight;

    return ConnectionWrapper(
      child: Material(
        color: Colors.transparent,
        child: GlassScaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          edgeToEdge: true,
          extendBody: true,
          edgeFade: false,
          background: Stack(
            children: [
              Container(color: theme.scaffoldBackgroundColor),
              Positioned(
                top: -60,
                right: -60,
                child: buildBlurBlob(primary.withValues(alpha: 0.35), 400),
              ),
              Positioned(
                top: 420,
                left: -120,
                child: buildBlurBlob(primary.withValues(alpha: 0.22), 380),
              ),
              Positioned(
                bottom: -60,
                right: -80,
                child: buildBlurBlob(primary.withValues(alpha: 0.28), 380),
              ),
            ],
          ),
          appBar: GlassAppBar(
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: EdgeInsets.only(left: RecipeMateAppUtil.screenWidth * 0.03),
              child: GlassIconButton(
                onPressed: () => Get.back(),
                size: RecipeMateAppUtil.screenWidth * 0.11,
                iconSize: RecipeMateAppUtil.screenWidth * 0.06,
                shape: GlassIconButtonShape.circle,
                icon: Icon(Icons.keyboard_arrow_left_rounded, color: theme.colorScheme.onSurface),
                settings: LiquidGlassSettings(
                  glassColor: theme.cardColor,
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
              text: AppLocalizations.of(context)!.stFavorites,
              fontSize: DimensText.headerMenusText(context),
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              fontFamily: 'times_new_roman_bold',
            ),
            centerTitle: true,
          ),
          body: Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.04),
                child: Column(
                  children: [
                    SizedBox(height: topReserved + RecipeMateAppUtil.screenHeight * 0.01),
                    // Search field using GlassTextField.search
                    GlassTextField.search(
                      controller: _searchController,
                      placeholder: AppLocalizations.of(context)!.stSearchFavorites,
                      height: RecipeMateAppUtil.screenHeight * 0.07,
                      onChanged: (val) => _searchQuery.value = val,
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.colorScheme.primary,
                        size: RecipeMateAppUtil.screenWidth * 0.06,
                      ),
                    ),
                    SizedBox(height: RecipeMateAppUtil.screenHeight * 0.025),
                    Obx(() {
                      if (_controller.isLoading.value && _controller.favorites.isEmpty) {
                        return Skeletonizer(
                          enabled: true,
                          child: Column(
                            children: List.generate(4, (_) => Container(
                              height: 80,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            )),
                          ),
                        );
                      }

                      final query = _searchQuery.value.toLowerCase();
                      final filtered = _controller.favorites.where((f) {
                        return f.title.toLowerCase().contains(query);
                      }).toList();

                      if (filtered.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: RecipeMateAppUtil.screenHeight * 0.15),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite_border, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                                const SizedBox(height: 16),
                                customText(
                                  text: AppLocalizations.of(context)!.stNoFavorites,
                                  fontSize: DimensText.bodyText(context),
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return GlassGroupedSection(
                        settings: _glassSettings(context),
                        children: filtered.map((recipe) {
                          return Dismissible(
                            key: Key(recipe.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              _controller.toggleFavorite(recipe);
                              AppSnackbar.show(
                                title: "Dihapus",
                                message: "${recipe.title} dihapus dari favorit",
                                duration: const Duration(seconds: 4),
                              );
                            },
                            child: CupertinoListTile(
                              onTap: () => Get.toNamed('/home_detail', arguments: recipe.id),
                              padding: EdgeInsets.symmetric(
                                horizontal: RecipeMateAppUtil.screenWidth * 0.03,
                                vertical: RecipeMateAppUtil.screenHeight * 0.015,
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: recipe.image != null && recipe.image!.isNotEmpty
                                    ? Image.network(
                                        recipe.image!,
                                        width: 55,
                                        height: 55,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Container(
                                          width: 55,
                                          height: 55,
                                          color: Colors.grey.withValues(alpha: 0.3),
                                          child: const Icon(Icons.fastfood),
                                        ),
                                      )
                                    : Container(
                                        width: 55,
                                        height: 55,
                                        color: Colors.grey.withValues(alpha: 0.3),
                                        child: const Icon(Icons.fastfood),
                                      ),
                              ),
                              title: customText(
                                text: recipe.title,
                                fontSize: DimensText.bodySmallText(context),
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                intMaxLine: 2,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    if (recipe.readyInMinutes != null) ...[
                                      Icon(Icons.timer, size: 13, color: theme.colorScheme.primary),
                                      const SizedBox(width: 4),
                                      customText(
                                        text: "${recipe.readyInMinutes} mnt",
                                        fontSize: DimensText.microText(context),
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                    if (recipe.aggregateLikes != null) ...[
                                      const Icon(Icons.favorite, size: 13, color: Colors.red),
                                      const SizedBox(width: 4),
                                      customText(
                                        text: "${recipe.aggregateLikes}",
                                        fontSize: DimensText.microText(context),
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    SizedBox(height: RecipeMateAppUtil.screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
