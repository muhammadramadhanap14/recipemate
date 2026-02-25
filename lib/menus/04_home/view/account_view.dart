import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/color_var.dart';
import '../../../utils/constant_var.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/account_view_model.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountViewModel accountViewModel = Get.put(
      //TODO ambil dari DB Lokasl
        AccountViewModel(
          dataSessionUtil: null
        ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _initViewAccount(context, accountViewModel),
    );
  }

  Widget _initViewAccount(BuildContext context, AccountViewModel accountViewModel) {
    RecipeMateAppUtil.init(context);
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: HexColor(ColorVar.bgGrayDataTable),
          padding: EdgeInsets.only(
            top: RecipeMateAppUtil.screenHeight * 0.04,
            bottom: RecipeMateAppUtil.screenHeight * 0.03,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: RecipeMateAppUtil.screenWidth * 0.22,
                height: RecipeMateAppUtil.screenWidth * 0.22,
                decoration: BoxDecoration(
                  color: HexColor(ColorVar.appColor),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/ic_icon_profile.png",
                    color: Colors.black,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => customText(
                text: accountViewModel.userName.value,
                fontSize: DimensText.headerText(context),
                fontWeight: FontWeight.bold,
              )),
              Obx(() => customText(
                text: "UserID: ${accountViewModel.userId.value}",
                fontSize: DimensText.accountNameText(context),
                color: Colors.black,
              )),
              Obx(() => customText(
                text: '',
                fontSize: DimensText.accountNameText(context),
                color: Colors.black,
              )),
              Obx(() => customText(
                text: accountViewModel.appVersion.value,
                fontSize: DimensText.accountNameText(context),
                color: Colors.black.withValues(alpha: 0.5),
              )),
            ],
          ),
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: RecipeMateAppUtil.screenWidth * 0.05,
              vertical: RecipeMateAppUtil.screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: ConstantVar.stAccountActivities,
                  fontSize: DimensText.accountNameText(context),
                  fontWeight: FontWeight.bold,
                ),

                const SizedBox(height: 4),
                const Divider(thickness: 1),
                const SizedBox(height: 14),

                customText(
                  text: ConstantVar.stLastLogin,
                  fontSize: DimensText.accountNameText(context),
                  fontWeight: FontWeight.bold,
                ),

                const SizedBox(height: 12),

                Obx(() => customText(
                  text: accountViewModel.lastLoginDate.value,
                  fontSize: DimensText.accountNameText(context),
                )),

                const Divider(thickness: 1),
                const SizedBox(height: 12),

                Obx(() => customText(
                  text: accountViewModel.lastLoginTime.value,
                  fontSize: DimensText.accountNameText(context),
                )),

                const Divider(thickness: 1),
                const Spacer(),

                // Logout Btn
                Align(
                  alignment: Alignment.centerLeft,
                  child: customElevatedButton(
                      fontColor: Colors.black,
                      fontSize: DimensText.buttonSmallText(context),
                      icon: const Icon(Icons.logout, color: Colors.black),
                      backgroundColor: HexColor(ColorVar.grayButton),
                      foregroundColor: HexColor(ColorVar.grayButton),
                      sideColor: HexColor(ColorVar.grayButton),
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          accountViewModel.logoutDialog(
                            ConstantVar.stConfirmLogout,
                            ConstantVar.confirmLogout,
                            ConstantVar.backBtnTitle,
                            ConstantVar.confirmGif,
                            context,
                          );
                        });
                      },
                      text: ConstantVar.logoutBtn
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}