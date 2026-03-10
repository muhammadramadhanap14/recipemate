import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/utils/constant_var.dart';
import 'package:recipemate/utils/dimens_text.dart';

import '../../../utils/recipemate_app_util.dart';
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
    
    final double fabSize = RecipeMateAppUtil.screenWidth * 0.192;
    final double barHeight = RecipeMateAppUtil.screenHeight * 0.098;
    final double iconSizeCenter = RecipeMateAppUtil.screenWidth * 0.085;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await viewModel.onWillPop();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Obx(() => viewModel.currentPage),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: isKeyboardVisible ? null : Container(
          height: fabSize,
          width: fabSize,
          margin: EdgeInsets.only(top: RecipeMateAppUtil.screenHeight * 0.029),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                blurRadius: RecipeMateAppUtil.screenWidth * 0.04,
                spreadRadius: 2,
                offset: Offset(0, RecipeMateAppUtil.screenHeight * 0.006),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed('/recipemate_ai');
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: CircleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.surface,
                width: RecipeMateAppUtil.screenWidth * 0.01,
              ),
            ),
            elevation: 0,
            child: Icon(
              Icons.auto_awesome,
              color: Theme.of(context).colorScheme.onPrimary,
              size: iconSizeCenter,
            ),
          ),
        ),
        bottomNavigationBar: isKeyboardVisible ? const SizedBox.shrink() : BottomAppBar(
          height: barHeight,
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 20,
          padding: EdgeInsets.symmetric(
            horizontal: RecipeMateAppUtil.screenWidth * 0.04,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                viewModel: viewModel,
                index: 0,
                icon: Icons.home_rounded,
                label: ConstantVar.home,
              ),
              SizedBox(width: RecipeMateAppUtil.screenWidth * 0.12),
              _buildNavItem(
                context: context,
                viewModel: viewModel,
                index: 1,
                icon: Icons.person_rounded,
                label: ConstantVar.akun,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required HomeNavViewModel viewModel,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final double iconSize = RecipeMateAppUtil.screenWidth * 0.075;

    return Obx(() {
      final isSelected = viewModel.selectedIndex.value == index;
      final color = isSelected 
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSecondary;
      
      return GestureDetector(
        onTap: () => viewModel.changePage(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: iconSize,
            ),
            SizedBox(height: RecipeMateAppUtil.screenHeight * 0.005),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: DimensText.buttonMicroText(context),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }
}