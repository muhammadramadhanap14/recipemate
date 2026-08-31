import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/utils/dimens_text.dart';

import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../../07_chat_session/view_model/chat_history_controller.dart';
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
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;

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
                top: -60,
                right: -60,
                child: buildBlurBlob(primary.withValues(alpha: 0.32), 380),
              ),
              Positioned(
                bottom: 180,
                left: -120,
                child: buildBlurBlob(primary.withValues(alpha: 0.22), 400),
              ),
              Positioned(
                top: 260,
                left: -60,
                child: buildBlurBlob(primary.withValues(alpha: 0.18), 260),
              ),
            ],
          ),
          body: Obx(() => viewModel.currentPage),
          bottomBar: isKeyboardVisible
            ? const SizedBox.shrink()
            : Padding(
            padding: EdgeInsets.only(
              bottom: RecipeMateAppUtil.screenHeight * 0.03,
              left: RecipeMateAppUtil.screenWidth * 0.15,
              right: RecipeMateAppUtil.screenWidth * 0.15,
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
                              Icons.nfc_rounded,
                              size: RecipeMateAppUtil.screenWidth * 0.065,
                            ),
                            activeIcon: Icon(
                              Icons.nfc_rounded,
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
                        selectedIconColor: Theme.of(context).colorScheme.onPrimary,
                        unselectedIconColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        indicatorColor: primary,
                        labelFontSize: DimensText.buttonMicroText(context),
                        barHeight: RecipeMateAppUtil.screenHeight * 0.075,
                        barBorderRadius: 35,
                        enableBlend: true,
                        settings: LiquidGlassSettings(
                          glassColor: cardColor,
                          backerColor: Colors.black.withValues(alpha: 0.06),
                          thickness: 100,
                          blur: 8,
                          chromaticAberration: 0.4,
                          lightIntensity: 1.2,
                          refractiveIndex: 1.68,
                          saturation: 1.1,
                          ambientStrength: 1.1,
                          ambientRim: 0.3,
                          edgeAbsorption: 0.12,
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
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    settings: LiquidGlassSettings(
                      glassColor: primary.withValues(alpha: 0.95),
                      backerColor: Colors.black.withValues(alpha: 0.02),
                      thickness: 80,
                      blur: 6,
                      chromaticAberration: 0.2,
                      lightIntensity: 1.3,
                      refractiveIndex: 1.7,
                      saturation: 1.1,
                      ambientStrength: 1.2,
                      ambientRim: 0.35,
                      edgeAbsorption: 0.15,
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