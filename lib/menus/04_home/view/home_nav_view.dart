import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../utils/recipemate_app_util.dart';
import '../../../utils/color_var.dart';
import '../view_model/home_nav_view_model.dart';

class HomeNavView extends StatelessWidget {
  const HomeNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeNavViewModel viewModel = Get.put(HomeNavViewModel());
    RecipeMateAppUtil.init(context);
    return PopScope(child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await viewModel.onWillPop();
        },
        child: Scaffold(
          backgroundColor: HexColor(ColorVar.bgAppColor),
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: Obx(() => ConvexAppBar(
            height: RecipeMateAppUtil.screenHeight * 0.06,
            items: [
              _buildTabItem(
                viewModel: viewModel,
                index: 0,
                asset: 'assets/images/ic_home.webp',
              ),
              _buildTabItem(
                viewModel: viewModel,
                index: 1,
                asset: 'assets/images/ic_account.webp',
              ),
            ],
            initialActiveIndex: viewModel.selectedIndex.value,
            backgroundColor: HexColor(ColorVar.appColor),
            activeColor: Colors.white,
            color: HexColor(ColorVar.appColor),
            onTap: (index) => viewModel.changePage(index),
          )),
          body: SafeArea(
              child: Container(
                color: HexColor(ColorVar.bgAppColor),
                child: Obx(() => viewModel.currentPage)),
          ),
        )
      )
    );
  }

  TabItem _buildTabItem({
    required HomeNavViewModel viewModel,
    required int index,
    required String asset,
  }) {
    final isSelected = viewModel.selectedIndex.value == index;
    return TabItem(
      icon: Opacity(
        opacity: isSelected ? 1.0 : 0.5,
        child: Container(
          padding: EdgeInsets.all(isSelected ? 6 : 0),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            asset,
            width: 30,
            height: 30,
            color: isSelected
                ? HexColor(ColorVar.appColor)
                : Colors.white,
            colorBlendMode: BlendMode.modulate,
          ),
        ),
      ),
    );
  }

}