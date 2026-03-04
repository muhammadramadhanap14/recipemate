import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';

import '../color_var.dart';
import '../constant_var.dart';
import '../dimens_text.dart';
import '../recipemate_app_util.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;
  const ErrorView({super.key, required this.errorMessage});


  @override
  Widget build(BuildContext context) {
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RecipeMateAppUtil.lockToPortrait();
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor(ColorVar.white),
      appBar: AppBar(
        backgroundColor: HexColor(ColorVar.appColor),
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.only(left: 18.0),
          child: customText(
            text: ConstantVar.menuErrorReport,
            fontSize: DimensText.headerMenusText(context),
            color: HexColor(ColorVar.black),
            fontFamily: 'inter_regular',
          ),
        ),
        leading: const SizedBox.shrink(),
      ),
      body: SafeArea(child: errorContent(context)),
    );
  }

  Widget errorContent(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: HexColor(ColorVar.bgBlue1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            offset: Offset(2, 3),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 100),
            const SizedBox(height: 12),
            customText(
                text: 'An error occurred:',
                fontWeight: FontWeight.bold,
                fontSize: DimensText.subHeaderText(context)
            ),
            const SizedBox(height: 6),
            customText(
              text: errorMessage,
              fontWeight: FontWeight.bold,
              fontSize: DimensText.subHeaderText(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              width: 200,
              margin: const EdgeInsets.only(left: 3, right: 3),
              child: customElevatedButton(
                  backgroundColor: HexColor(ColorVar.appColor),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: errorMessage));
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacementNamed('/');
                    });
                  },
                  text: 'Restart Aplikasi',
                  fontSize: DimensText.buttonText(context)
              ),
            )
          ],
        ),
      ),
    );
  }
}