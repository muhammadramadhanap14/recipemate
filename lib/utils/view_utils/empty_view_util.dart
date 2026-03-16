import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import '../../l10n/app_localizations.dart';
import '../color_var.dart';
import '../dimens_text.dart';

class EmptyViewUtil extends StatelessWidget {
  final bool isFullScreen;
  const EmptyViewUtil({
    super.key,
    required this.isFullScreen,
  });

  @override
  Widget build(BuildContext context) {
    return isFullScreen ? Container(
      width: double.infinity,
      height: double.infinity,
      color: HexColor(ColorVar.bgAppColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/ic_no_data.webp',
              width: 200, height: 120),
          const SizedBox(height: 30),
          customText(
            text: AppLocalizations.of(context)!.stNotFound,
            fontSize: DimensText.headerText(context),
            color: HexColor(ColorVar.black),
            fontFamily: 'inter_bold',
            intMaxLine: null
          ),
        ],
      ),
    ) : Wrap(
        children: <Widget>[
          Container(
              width: double.infinity,
              color: HexColor(ColorVar.bgAppColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/ic_no_data.webp',
                      width: 200, height:  110),
                  const SizedBox(height: 30),
                  customText(
                      text: AppLocalizations.of(context)!.stNotFound,
                      fontSize: DimensText.headerText(context),
                      fontFamily: 'inter_bold',
                  )
                ],
              )
          )
        ]
    );
  }
}