import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/preference_food_view_model.dart';

class PreferenceFoodSatuView extends StatelessWidget {
  const PreferenceFoodSatuView({super.key});

  @override
  Widget build(BuildContext context) {
    final PreferenceFoodViewModel viewModel = Get.put(PreferenceFoodViewModel());
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RecipeMateAppUtil.lockToPortrait();
    });

    final double screenW = RecipeMateAppUtil.screenWidth;
    final double screenH = RecipeMateAppUtil.screenHeight;

    return PopScope(
      canPop: false,
      child: ConnectionWrapper(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenW * 0.06,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenH * 0.025),
                            _buildProgress(context, screenW, screenH),
                            SizedBox(height: screenH * 0.03),
                            _buildTitle(context, screenH),
                            SizedBox(height: screenH * 0.04),

                            _buildInputLabel(context, AppLocalizations.of(context)!.stShortname, screenW, screenH),

                            TextFormField(
                              focusNode: FocusNode(),
                              keyboardType: TextInputType.name,
                              onChanged: viewModel.setName,
                              style: TextStyle(
                                fontSize: DimensText.captionText(context),
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: 'e.g. Alex Dards',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                                filled: true,
                                fillColor: Theme.of(context).cardColor,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: screenH * 0.02,
                                  horizontal: screenW * 0.04,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            SizedBox(height: screenH * 0.025),

                            _buildInputLabel(context, AppLocalizations.of(context)!.stAge, screenW, screenH),

                            TextFormField(
                              focusNode: FocusNode(),
                              keyboardType: TextInputType.number,
                              onChanged: viewModel.setAge,
                              style: TextStyle(
                                fontSize: DimensText.captionText(context),
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: 'e.g. 25',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                                filled: true,
                                fillColor: Theme.of(context).cardColor,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: screenH * 0.02,
                                  horizontal: screenW * 0.04,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            SizedBox(height: screenH * 0.025),

                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInputLabel(context, AppLocalizations.of(context)!.stHeight, screenW, screenH),
                                      TextFormField(
                                        focusNode: FocusNode(),
                                        keyboardType: TextInputType.number,
                                        onChanged: viewModel.setHeight,
                                        style: TextStyle(
                                          fontSize: DimensText.captionText(context),
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: '170',
                                          hintStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context).cardColor,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: screenH * 0.02,
                                            horizontal: screenW * 0.04,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: screenW * 0.04),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInputLabel(context, AppLocalizations.of(context)!.stWeight, screenW, screenH),

                                      TextFormField(
                                        focusNode: FocusNode(),
                                        keyboardType: TextInputType.number,
                                        onChanged: viewModel.setWeight,
                                        style: TextStyle(
                                          fontSize: DimensText.captionText(context),
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: '65',
                                          hintStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context).cardColor,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: screenH * 0.02,
                                            horizontal: screenW * 0.04,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),
                            SizedBox(height: screenH * 0.03),
                            _buildNextButton(context, viewModel, screenW, screenH),
                            SizedBox(height: screenH * 0.025),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      )
    );
  }

  Widget _buildInputLabel(BuildContext context, String text, double screenW, double screenH) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenH * 0.01, left: screenW * 0.01),
      child: customText(
        text: text,
        fontSize: DimensText.microText(context),
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildProgress(BuildContext context, double screenW, double screenH) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
              text: AppLocalizations.of(context)!.stStep1of3,
              fontSize: DimensText.captionText(context),
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
            ),
            customText(
              text: "33%",
              fontSize: DimensText.captionText(context),
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary
            ),
          ],
        ),
        SizedBox(height: screenH * 0.01),
        ClipRRect(
          borderRadius: BorderRadius.circular(screenW * 0.025),
          child: LinearProgressIndicator(
            value: 0.33,
            minHeight: screenH * 0.01,
            backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, double screenH) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: AppLocalizations.of(context)!.stgreetPrefFood,
          fontSize: DimensText.headerText(context),
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: 'inter_bold',
        ),
        SizedBox(height: screenH * 0.01),
        customText(
          text: AppLocalizations.of(context)!.stgreetPrefFood2,
          fontSize: DimensText.captionText(context),
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          intMaxLine: null,
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context, PreferenceFoodViewModel viewModel, double screenW, double screenH) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: customElevatedButton(
          onPressed: viewModel.isStep1Valid ? () => Get.toNamed('/preference_food_dua') : null,
          backgroundColor: Theme.of(context).colorScheme.primary,
          sideColor: Theme.of(context).colorScheme.primary,
          borderRadius: screenW * 0.04,
          text: AppLocalizations.of(context)!.stNextBtn,
          fontSize: DimensText.buttonText(context),
          fontColor: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          padding: EdgeInsets.symmetric(vertical: screenH * 0.022)),
      );
    });
  }
}