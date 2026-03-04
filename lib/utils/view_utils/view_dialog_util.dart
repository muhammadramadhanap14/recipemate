import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';

import '../../models/model_util/model_three_column.dart';
import '../recipemate_app_util.dart';
import '../color_var.dart';
import '../constant_var.dart';
import '../dimens_text.dart';

class ViewDialogUtil {

  void getXSnackBar(
      String title,
      String message,
      String bgColor,
      String fontColor,
      {
        int durationSnackBar = 2,
      }
      ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP, // Or TOP
      backgroundColor: HexColor(bgColor).withValues(alpha: 0.7),
      colorText: HexColor(fontColor),
      margin: const EdgeInsets.all(8),
      duration: Duration(seconds: durationSnackBar),
    );
  }

  void showYesNoActionDialog(String content, String positiveTitle,
      String negativeTitle, String pictureParam,
      dynamic intentData,
      BuildContext context,
      Function(dynamic model) positiveClick,
      ) {
    showDialog(
        context: context,
        barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            final screenWidth = MediaQuery.of(dialogContext).size.width;
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              backgroundColor: HexColor(ColorVar.white),
              child: Container(
                width: screenWidth * 0.7,
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/images/$pictureParam', width: 150, height: 60),
                    const SizedBox(height: 15),
                    customText(
                      text: content,
                      textAlign: TextAlign.center,
                      color: HexColor(ColorVar.black),
                      isSoftWrap: true,
                      intMaxLine: 3,
                      fontSize: DimensText.subHeaderText(context),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: customOutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              text: negativeTitle,
                              borderColor: HexColor(ColorVar.bgGray72),
                              fontColor: HexColor(ColorVar.bgGray72),
                              fontSize: DimensText.buttonText(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: customRawMaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                positiveClick(intentData);
                              },
                              text: positiveTitle,
                              backgroundColor: HexColor(ColorVar.appColor),
                              fontSize: DimensText.buttonSmallText(context),
                              douWidth: 105,
                              douHeight: 40
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
  }

  void showOneButtonActionDialog(
      String content, String btnTitle,
      String pictureParam,BuildContext context,
      dynamic intentData,
      Function(dynamic model) onClick,
      ) {

    showDialog(
        context: context,
        barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            final screenWidth = MediaQuery.of(dialogContext).size.width;
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              backgroundColor: HexColor(ColorVar.white),
              child: Container(
                width: screenWidth * 0.7,
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/images/$pictureParam', width: 150, height: 60),
                    const SizedBox(height: 15),
                    customText(
                      text: content,
                      textAlign: TextAlign.center,
                      color: HexColor(ColorVar.black),
                      isSoftWrap: true,
                      intMaxLine: 3,
                      fontSize: DimensText.subHeaderText(context),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: customTextButton(
                          text: btnTitle,
                          fontColor: HexColor(ColorVar.black),
                          fontSize: DimensText.buttonText(context),
                          onPressed: () {
                            Navigator.of(context).pop();
                            onClick(intentData);
                          }),
                    ),
                  ],
                ),
              ),
            );
          }
        );
  }

  //jika dibutuhkan untuk searching one column
  void dialogSearchOneColumn(
      BuildContext context,
      List<ModelThreeColumn> list,
      String titleDialog,
      void Function(ModelThreeColumn selectedModel) selectedClick,
      ) {
    // Kunci orientasi ke portrait
    RecipeMateAppUtil.lockToPortrait();

    List<ModelThreeColumn> tempList = List.from(list);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (stfContext, stfSetState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: HexColor(ColorVar.white),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 355,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: HexColor(ColorVar.appColor),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Center(
                      child: customText(
                          text: titleDialog,
                          fontSize: 18,
                          color: HexColor(ColorVar.white),
                          fontFamily: 'inter_bold'
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customTextField(context: context,
                        onChanged: (value) {
                          stfSetState(() {
                            if (value.isNotEmpty) {
                              tempList = list.where((equipment) =>
                                  equipment.column2
                                      .toLowerCase()
                                      .contains(value.toLowerCase())).toList();
                            } else {
                              tempList = List.from(list);
                            }
                          });
                        },
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search ..',
                      borderRadius: 5
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 1.0),
                      child: tempList.isNotEmpty
                          ? ListView.builder(
                          itemCount: tempList.length,
                          itemBuilder: (context, index) {
                            final model = tempList[index];
                            return InkWell(
                              onTap: () {
                                if (model.column1 != '0') {
                                  Navigator.of(context).pop();
                                  selectedClick(model);
                                } else {
                                  getXSnackBar(
                                      ConstantVar.stWarning,
                                      'Mohon dipilih yang benar',
                                      ColorVar.redStatus,
                                      ColorVar.white);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 13, vertical: 13),
                                color: index % 2 == 0
                                    ? HexColor(ColorVar.bgDtlDataTable)
                                    : Colors.transparent,
                                child: customText(
                                  text: model.column2,
                                  fontSize: 14,
                                  color: HexColor(ColorVar.black),
                                  fontFamily:'inter_regular'
                                ),
                              ),
                            );
                          })
                          : Center(
                            child: customText(text: 'no Data Found'),
                      ), // Lebih baik dari SizedBox.shrink()
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        fillColor: HexColor(ColorVar.redText),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: customText(
                            text: ConstantVar.stCancelTitle,
                            color: HexColor(ColorVar.white),
                            fontSize: DimensText.buttonText(context),
                            fontFamily: 'inter_regular'
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}