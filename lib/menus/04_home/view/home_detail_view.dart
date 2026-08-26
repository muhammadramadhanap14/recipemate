import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_texture/liquid_glass_texture.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/model_response/detail_recipe_response.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/no_data_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../../../utils/view_utils/connection_wrapper.dart';
import '../../07_chat_session/view/view_model/chat_history_controller.dart';
import '../view_model/home_detail_view_model.dart';

class HomeDetailView extends StatelessWidget {
  const HomeDetailView({super.key});

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
  Widget build(BuildContext context) {
    final dynamic arguments = Get.arguments;
    final int? recipeId = arguments is int ? arguments : null;
    if (recipeId == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: NoDataUtil()),
      );
    }

    final HomeDetailViewModel viewModel = Get.put(
      HomeDetailViewModel(
        apiRepository: Get.find<ApiRepository>(),
        recipeId: recipeId,
      )
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
          edgeToEdge: true,
          extendBody: true,
          edgeFade: false,
          background: Stack(
            children: [
              Container(color: Theme.of(context).scaffoldBackgroundColor),
              Positioned(
                top: -60,
                right: -60,
                child: buildBlurBlob(primary.withValues(alpha: 0.35), 400),
              ),
              Positioned(
                top: 500,
                left: -120,
                child: buildBlurBlob(primary.withValues(alpha: 0.22), 380),
              ),
              Positioned(
                top: 1000,
                right: -100,
                child: buildBlurBlob(primary.withValues(alpha: 0.25), 360),
              ),
              Positioned(
                bottom: -60,
                left: -80,
                child: buildBlurBlob(primary.withValues(alpha: 0.3), 380),
              ),
            ],
          ),
          bodyOverlays: [
            Positioned(
              right: 25,
              bottom: 25,
              child: LiquidGlassFloatingActionButton(
                size: 70,
                onPressed: () {
                  final chatHistoryController = Get.find<ChatHistoryController>();
                  final session = chatHistoryController.createNewSession();
                  final recipeName = viewModel.recipeDetail.value?.title ?? "";
                  Get.toNamed('/chat', arguments: {
                    'session': session,
                    'initialMessage': "bantu saya buatkan masakan $recipeName",
                  });
                },
                child: Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary, size: 35),
              ),
            ),
          ],
          body: Obx(() {
            if (viewModel.isLoading.value) {
              return Center(child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ));
            }
            final DetailRecipeResponse? recipe = viewModel.recipeDetail.value;
            if (recipe == null) {
              return const Center(child: NoDataUtil());
            }
            return Material(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageHeader(context, recipe.image ?? ""),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: RecipeMateAppUtil.screenWidth * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
                          _buildTitleSection(context, recipe),
                          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
                          _buildTagsSection(context, recipe),
                          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
                          _buildNutritionalCard(context, recipe),
                          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
                          _buildSummaryCard(context, recipe.summary ?? ''),
                          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
                          _buildIngredientsSection(context, recipe.extendedIngredients ?? []),
                          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
                          _buildInstructionsSection(context, recipe.analyzedInstructions ?? []),
                          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03 + 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
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
                GlassIconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.chevron_left),
                  size: RecipeMateAppUtil.screenWidth * 0.12,
                  iconSize: RecipeMateAppUtil.screenWidth * 0.07,
                  settings: const LiquidGlassSettings(
                    glassColor: Colors.transparent,
                    backerColor: Colors.black38,
                    thickness: 90,
                    blur: 6,
                    chromaticAberration: 0.4,
                    lightIntensity: 1.1,
                    refractiveIndex: 1.65,
                    saturation: 1.0,
                    ambientStrength: 1.1,
                    ambientRim: 0.3,
                    edgeAbsorption: 0.1,
                  ),
                  useOwnLayer: true
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context, DetailRecipeResponse recipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: recipe.title ?? "",
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: DimensText.subHeaderLargeText(context),
          fontWeight: FontWeight.w700,
          intMaxLine: null
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
        Row(
          children: [
            GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              settings: LiquidGlassSettings(
                glassColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
                backerColor: Colors.black.withValues(alpha: 0.02),
                thickness: 60,
                blur: 5,
                chromaticAberration: 0.2,
                lightIntensity: 1.2,
                refractiveIndex: 1.65,
                ambientRim: 0.3,
                edgeAbsorption: 0.1,
              ),
              child: Icon(
                Icons.access_time_filled,
                color: Theme.of(context).colorScheme.onPrimary,
                size: RecipeMateAppUtil.screenWidth * 0.05
              ),
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.015),
            customText(
              text: "${recipe.readyInMinutes} mins",
              fontSize: DimensText.bodySmallText(context),
              color: Theme.of(context).colorScheme.onSurface
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.04),
            GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              settings: LiquidGlassSettings(
                glassColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
                backerColor: Colors.black.withValues(alpha: 0.02),
                thickness: 60,
                blur: 5,
                chromaticAberration: 0.2,
                lightIntensity: 1.2,
                refractiveIndex: 1.65,
                ambientRim: 0.3,
                edgeAbsorption: 0.1,
              ),
              child: Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.onPrimary,
                size: RecipeMateAppUtil.screenWidth * 0.05
              ),
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.015),
            customText(
              text: "Score: ${recipe.spoonacularScore?.toStringAsFixed(1) ?? "0"}",
              fontSize: DimensText.bodySmallText(context),
              color: Theme.of(context).colorScheme.onSurface
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context, DetailRecipeResponse recipe) {
    final List<String> tags = [];
    if (recipe.vegetarian == true) tags.add("Vegetarian");
    if (recipe.vegan == true) tags.add("Vegan");
    if (recipe.glutenFree == true) tags.add("Gluten Free");
    if (recipe.dairyFree == true) tags.add("Dairy Free");
    if (recipe.veryHealthy == true) tags.add("Healthy");
    if (recipe.cheap == true) tags.add("Cheap");
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: tags.map((tag) => GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        settings: _glassSettings(context),
        child: customText(
          text: tag,
          fontSize: DimensText.bodySmallText(context),
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      )).toList(),
    );
  }

  Widget _buildNutritionalCard(BuildContext context, DetailRecipeResponse recipe) {
    final nutrients = recipe.nutrition?.nutrients ?? [];
    Nutrients getNutrient(String name) => nutrients.firstWhere(
          (n) => n.name == name,
      orElse: () => Nutrients(amount: 0, unit: "", percentOfDailyNeeds: 0),
    );
    final spacingH = RecipeMateAppUtil.screenWidth * 0.04;
    final spacingV = RecipeMateAppUtil.screenHeight * 0.015;

    final kcalNutrient = getNutrient("Calories");
    final kcal = kcalNutrient.amount;
    final kcalPercent =
    ((kcalNutrient.percentOfDailyNeeds ?? 0) / 100).clamp(0.0, 1.0);

    final protein = getNutrient("Protein");
    final carbs = getNutrient("Carbohydrates");
    final fat = getNutrient("Fat");
    final sugar = getNutrient("Sugar");
    final cholesterol = getNutrient("Cholesterol");
    final sodium = getNutrient("Sodium");

    return GlassCard(
      padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.05),
      shape: LiquidRoundedRectangle(
        borderRadius: RecipeMateAppUtil.screenWidth * 0.06,
      ),
      settings: _glassSettings(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            text: AppLocalizations.of(context)!.stNutritionalPrediction,
            fontSize: DimensText.headerMenusText(context),
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.025),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: RecipeMateAppUtil.screenWidth * 0.28,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: RecipeMateAppUtil.screenWidth * 0.22,
                          height: RecipeMateAppUtil.screenWidth * 0.22,
                          child: CircularProgressIndicator(
                            value: kcalPercent,
                            strokeWidth: RecipeMateAppUtil.screenWidth * 0.02,
                            backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Column(
                          children: [
                            customText(
                              text: kcal?.toInt().toString() ?? "0",
                              fontSize: DimensText.bodyText(context),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            customText(
                              text: "KCAL",
                              fontSize:
                              DimensText.captionText(context),
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacingH),
              Expanded(
                child: Column(
                  children: [
                    _buildRowNutrient(context,
                      _buildNutrientItem(context, "PROTEIN", "${protein.amount?.toInt()}${protein.unit}"),
                      _buildNutrientItem(context, "SUGAR", "${sugar.amount?.toInt()}${sugar.unit}"),
                    ),
                    SizedBox(height: spacingV),
                    _buildRowNutrient(context,
                      _buildNutrientItem(context, "CARBS", "${carbs.amount?.toInt()}${carbs.unit}"),
                      _buildNutrientItem(context, "CHOL.", "${cholesterol.amount?.toInt()}${cholesterol.unit}"),
                    ),
                    SizedBox(height: spacingV),
                    _buildRowNutrient(context,
                      _buildNutrientItem(context, "FATS", "${fat.amount?.toInt()}${fat.unit}"),
                      _buildNutrientItem(context, "SODIUM", "${sodium.amount?.toInt()}${sodium.unit}"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRowNutrient(
      BuildContext context, Widget left, Widget right) {
    return Row(
      children: [
        Expanded(child: left),
        SizedBox(width: RecipeMateAppUtil.screenWidth * 0.03),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildNutrientItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: label, 
          fontSize: DimensText.captionText(context),
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: FontWeight.bold
        ),
        customText(
          text: value,
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: DimensText.bodyText(context),
          fontWeight: FontWeight.bold
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, String summary) {
    return GlassCard(
      padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.05),
      shape: LiquidRoundedRectangle(
        borderRadius: RecipeMateAppUtil.screenWidth * 0.06,
      ),
      settings: _glassSettings(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            text: AppLocalizations.of(context)!.stRecipeSummary,
            fontSize: DimensText.headerMenusText(context),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
          GlassContainer(
            padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.04),
            useOwnLayer: true,
            settings: LiquidGlassSettings(
              glassColor: Colors.black.withValues(alpha: 0.05),
              backerColor: Colors.black.withValues(alpha: 0.08),
              thickness: 60,
              blur: 6,
              chromaticAberration: 0.25,
              lightIntensity: 1.1,
              refractiveIndex: 1.6,
              ambientRim: 0.2,
              edgeAbsorption: 0.15,
            ),
            child: Html(
              data: summary,
              style: {
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(DimensText.bodyText(context)),
                  color: Theme.of(context).colorScheme.onSurface,
                  lineHeight: LineHeight(1.5),
                ),
                "b": Style(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                "a": Style(
                  color: Colors.blue,
                  textDecoration: TextDecoration.none,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection(BuildContext context, List<ExtendedIngredients> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: AppLocalizations.of(context)!.stCoreIngredients,
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: DimensText.headerMenusText(context),
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
              final double size = RecipeMateAppUtil.screenWidth * 0.22;
              final String fullImageUrl = "https://spoonacular.com/cdn/ingredients_100x100/${item.image}";
              final String formattedAmount = item.amount != null
                ? (item.amount! % 1 == 0 ? item.amount!.toInt().toString() : item.amount!.toStringAsFixed(1))
                : "";
              return Column(
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onPrimary,
                      border: Border.all(color: Theme.of(context).cardColor, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        fullImageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (
                          context, error, stackTrace) => Icon(Icons.restaurant_menu, color: Theme.of(context).colorScheme.primary
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.01),
                  Expanded(
                    child: customText(
                      text: item.name ?? "",
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: DimensText.bodySmallText(context),
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      intMaxLine: null
                    ),
                  ),
                  customText(
                    text: "$formattedAmount ${item.unit}",
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: DimensText.bodySmallText(context),
                    fontWeight: FontWeight.w500,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection(BuildContext context, List<AnalyzedInstructions> instructions) {
    if (instructions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: AppLocalizations.of(context)!.stInstructions,
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: DimensText.headerMenusText(context),
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
        ...instructions.map((instruction) {
          final steps = instruction.steps ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(steps.length, (index) {
              final step = steps[index];
              final isLastStep = index == steps.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        GlassContainer(
                          width: RecipeMateAppUtil.screenWidth * 0.08,
                          height: RecipeMateAppUtil.screenWidth * 0.08,
                          alignment: Alignment.center,
                          settings: LiquidGlassSettings(
                            glassColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
                            backerColor: Colors.black.withValues(alpha: 0.02),
                            thickness: 60,
                            blur: 5,
                            chromaticAberration: 0.2,
                            lightIntensity: 1.2,
                            refractiveIndex: 1.65,
                            ambientRim: 0.3,
                            edgeAbsorption: 0.1,
                          ),
                          child: customText(
                            text: "${step.number}",
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: DimensText.bodySmallText(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isLastStep)
                          Expanded(
                            child: GlassContainer(
                              width: 2,
                              settings: LiquidGlassSettings(
                                glassColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                                thickness: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: RecipeMateAppUtil.screenWidth * 0.04),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLastStep ? 0 : 20.0),
                        child: customText(
                          text: step.step ?? "",
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: DimensText.bodyText(context),
                          intMaxLine: null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}