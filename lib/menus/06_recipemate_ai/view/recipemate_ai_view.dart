import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../utils/constant_var.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/color_var.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/recipemate_ai_view_model.dart';

class RecipemateAiView extends StatelessWidget {
  const RecipemateAiView({super.key});

  @override
  Widget build(BuildContext context) {
    final RecipemateAiViewModel viewModel = Get.put(RecipemateAiViewModel());
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    return Scaffold(
      backgroundColor: HexColor(ColorVar.bgAppColor),
      appBar: AppBar(
        backgroundColor: HexColor(ColorVar.bgAppColor),
        centerTitle: true,
        title: customText(
          text: ConstantVar.recipeMateAi,
          fontSize: DimensText.headerMenusText(context),
          fontWeight: FontWeight.bold,
          color: HexColor(ColorVar.black),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: RecipeMateAppUtil.screenWidth * 0.06,
          ),
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}