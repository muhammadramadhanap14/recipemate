import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../utils/recipemate_app_util.dart';
import '../../../utils/color_var.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeViewModel homeViewModel = Get.put(
        HomeViewModel(
            dataSessionUtil: null
        ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _initViewHome(context, homeViewModel),
    );
  }

  Widget _initViewHome(BuildContext context, HomeViewModel homeViewModel) {
    RecipeMateAppUtil.init(context);
    return Column(
      children: [
        SizedBox(
          height: RecipeMateAppUtil.screenHeight * 0.2,
          child : SafeArea(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: HexColor(ColorVar.appColor), // Green color
              ),
              child: Padding(
                padding: EdgeInsets.only(left: RecipeMateAppUtil.screenWidth * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
                  children: [
                    Obx(() => customText(
                      text: "Hi, ${homeViewModel.nameUser.value} ...",
                      fontSize: DimensText.headerText(context), // Adjusted font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                    SizedBox(height: RecipeMateAppUtil.screenHeight * 0.005),
                    customText(
                      text: "Welcome !",
                      fontSize: DimensText.superHeaderText(context), // Adjusted font size
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            )
          )
        ),
        Expanded(
          flex: 5,
          child: Container(
            padding: EdgeInsets.all(RecipeMateAppUtil.screenHeight * 0.03),
          )
        )
      ],
    );
  }
}