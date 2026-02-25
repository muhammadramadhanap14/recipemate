import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../utils/recipemate_app_util.dart';
import '../../../utils/color_var.dart';
import '../../../utils/constant_var.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/splash_view_model.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final splashViewModel = Get.put(SplashViewModel(
        context: context,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: RecipeMateAppUtil.initOrientation(context) == Orientation.portrait
            ? _initViewSplash(context, splashViewModel)
            : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: _initViewSplash(context, splashViewModel),
        )
      ),
    );
  }

  Widget _initViewSplash(BuildContext context, SplashViewModel viewModel) {
    final isPortrait = RecipeMateAppUtil.initOrientation(context) == Orientation.portrait;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isPortrait) const SizedBox(height: 50),
        Center(
          child: Image.asset(
            'assets/images/ic_ilova_hadato.webp',
            width: 180,
            height: 180,
          ),
        ),
        Obx(() {
          final isLoading = viewModel.isLoading.value == true;
          if (isLoading) {
            return Column(
              children: [
                Image.asset(
                  'assets/images/ic_loading.gif',
                  width: isPortrait ? 100 : 80,
                  height: isPortrait ? 80 : 40,
                ),
                SizedBox(height: isPortrait ? 10 : 5),
              ],
            );
          } else {
            return SizedBox(height: isPortrait ? 30 : 20);
          }
        }),
        _initTextSplash(context, RecipeMateAppUtil.initOrientation(context)),

        if (isPortrait) const SizedBox(height: 60),
      ],
    );
  }


  Widget _initTextSplash(BuildContext context, Orientation orientation) => customText(
    text: ConstantVar.appNameForMenu,
    fontSize: orientation == Orientation.portrait
        ? DimensText.superHeaderText(context)
        : DimensText.headerText(context),
    color: HexColor(ColorVar.bgGray8),
    fontFamily: 'inter_regular',
  );
}