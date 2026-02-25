import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';

import '../recipemate_app_util.dart';
import '../color_var.dart';
import '../dimens_text.dart';

class LoadingViewUtil extends StatelessWidget {
  final bool isFullScreen;
  const LoadingViewUtil({
    super.key,
    required this.isFullScreen
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });
     return isFullScreen
         ? Container(
             width: double.infinity,
             height: double.infinity,
             color: HexColor(ColorVar.bgAppColor),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Image.asset('assets/images/ic_loading.gif',
                     width: 200, height: 110),
                 const SizedBox(height: 50),
                 customText(
                   text: 'Loading ...',
                   fontSize: DimensText.headerText(context),
                   fontFamily: 'inter_bold',
                 )
               ],
             ),
          )
         : Wrap(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: HexColor(ColorVar.bgAppColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/ic_loading.gif',
                      width: 200, height: 110),
                  const SizedBox(height: 50),
                  customText(
                    text: 'Loading ...',
                    fontSize: DimensText.headerText(context),
                    fontFamily: 'inter_bold',
                  )
                ],
              ),
            )
          ],
     );
  }

}