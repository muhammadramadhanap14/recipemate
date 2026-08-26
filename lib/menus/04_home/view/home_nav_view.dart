import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/utils/dimens_text.dart';

import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../../07_chat_session/view/view_model/chat_history_controller.dart';
import '../view_model/home_nav_view_model.dart';

class HomeNavView extends StatelessWidget {
  const HomeNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeNavViewModel viewModel = Get.put(HomeNavViewModel());
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    final double iconSizeCenter = RecipeMateAppUtil.screenWidth * 0.085;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await viewModel.onWillPop(context);
      },
      child: Material(
        child: GlassScaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          edgeToEdge: true,
          extendBody: true,
          edgeFade: false,
          resizeToAvoidBottomInset: true,
          background: Stack(
            children: [
              Container(color: Theme.of(context).scaffoldBackgroundColor),
              Positioned(
                top: -50,
                right: -50,
                child: buildBlurBlob(
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  350,
                ),
              ),
              Positioned(
                bottom: 200,
                left: -100,
                child: buildBlurBlob(
                  Colors.deepPurple.withValues(alpha: 0.1),
                  400,
                ),
              ),
              Positioned(
                top: 250,
                left: -50,
                child: buildBlurBlob(
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  250,
                ),
              ),
            ],
          ),
          body: Obx(() => viewModel.currentPage),
          bottomBar: isKeyboardVisible
          ? const SizedBox.shrink() : Padding(
            padding: EdgeInsets.only(
              bottom: RecipeMateAppUtil.screenHeight * 0.03,
              left: RecipeMateAppUtil.screenWidth * 0.21,
              right: RecipeMateAppUtil.screenWidth * 0.21,
            ),
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Obx(
                      () => GlassTabBar.inline(
                        selectedIndex: viewModel.selectedIndex.value,
                        onTabSelected: (index) {
                          viewModel.changePage(index);
                        },
                        tabs: [
                          GlassTab(
                            icon: Icon(
                              Icons.home_rounded,
                              size: RecipeMateAppUtil.screenWidth * 0.065,
                            ),
                            activeIcon: Icon(
                              Icons.home_rounded,
                              size: RecipeMateAppUtil.screenWidth * 0.07,
                            ),
                          ),
                          GlassTab(
                            icon: Icon(
                              Icons.person_rounded,
                              size: RecipeMateAppUtil.screenWidth * 0.065,
                            ),
                            activeIcon: Icon(
                              Icons.person_rounded,
                              size: RecipeMateAppUtil.screenWidth * 0.07,
                            ),
                          ),
                        ],
                        selectedLabelColor: Theme.of(context).colorScheme.primary,
                        selectedIconColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        unselectedIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        labelFontSize: DimensText.buttonMicroText(context),
                        barHeight: RecipeMateAppUtil.screenHeight * 0.075,
                        barBorderRadius: 35,
                        enableBlend: true,
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
                    ),
                  ),

                  const SizedBox(width: 12),

                  GlassIconButton(
                    size: RecipeMateAppUtil.screenHeight * 0.075,
                    iconSize: iconSizeCenter,
                    shape: GlassIconButtonShape.circle,
                    onPressed: () {
                      final historyController = Get.find<ChatHistoryController>();
                      final session = historyController.createNewSession();
                      Get.toNamed('/chat', arguments: session);
                    },
                    icon: Icon(
                      Icons.auto_awesome,
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
            ),
          ),
        ),
      ),
    );
  }
}
