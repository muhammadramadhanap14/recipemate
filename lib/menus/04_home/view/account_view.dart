import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../utils/constant_var.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/color_var.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/account_view_model.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountViewModel viewModel = Get.put(AccountViewModel());
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
          text: ConstantVar.akun,
          fontSize: DimensText.headerMenusText(context),
          fontWeight: FontWeight.bold,
          color: HexColor(ColorVar.black),
          fontFamily: 'times_new_roman_bold',
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
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.025),
              _buildProfileHeader(context, viewModel),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.05),
              _buildMenuItem(
                context: context,
                icon: Icons.language,
                title: "Language",
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customText(
                      text: "English",
                      fontSize: DimensText.captionText(context),
                      color: HexColor(ColorVar.bgGray8),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down, 
                      color: HexColor(ColorVar.bgGray8),
                      size: RecipeMateAppUtil.screenWidth * 0.05,
                    ),
                  ],
                ),
                onTap: () {},
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
              _buildMenuItem(
                context: context,
                icon: Icons.dark_mode,
                title: "Dark Mode",
                trailing: Obx(() => Switch(
                  value: viewModel.isDarkMode.value,
                  activeTrackColor: HexColor(ColorVar.appColor).withValues(alpha: 0.3),
                  activeThumbColor: HexColor(ColorVar.appColor),
                  onChanged: viewModel.toggleDarkMode,
                )),
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
              _buildMenuItem(
                context: context,
                icon: Icons.logout,
                title: "Logout",
                titleColor: HexColor(ColorVar.appColor),
                iconColor: HexColor(ColorVar.appColor),
                trailing: Icon(
                  Icons.chevron_right, 
                  color: HexColor(ColorVar.bgGray8),
                  size: RecipeMateAppUtil.screenWidth * 0.06,
                ),
                onTap: () => viewModel.logoutDialog(context),
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AccountViewModel viewModel) {
    final double profileSize = RecipeMateAppUtil.screenWidth * 0.35;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: profileSize,
              height: profileSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: HexColor(ColorVar.appColor).withValues(alpha: 0.1), 
                  width: RecipeMateAppUtil.screenWidth * 0.01,
                ),
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/profile_pict_icon.png"),
                backgroundColor: Colors.transparent,
              ),
            ),
            Positioned(
              bottom: RecipeMateAppUtil.screenWidth * 0.01,
              right: RecipeMateAppUtil.screenWidth * 0.01,
              child: Container(
                padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.015),
                decoration: BoxDecoration(
                  color: HexColor(ColorVar.appColor),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: HexColor(ColorVar.white),
                    width: RecipeMateAppUtil.screenWidth * 0.005,
                  ),
                ),
                child: Icon(
                  Icons.edit, 
                  color: HexColor(ColorVar.white),
                  size: RecipeMateAppUtil.screenWidth * 0.04,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
        Obx(() => customText(
          text: viewModel.userName.value,
          fontSize: DimensText.subHeaderLargeText(context),
          fontWeight: FontWeight.w900,
          color: HexColor(ColorVar.black),
          fontFamily: 'times_new_roman_bold'
        )),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.002),
        Obx(() => customText(
          text: viewModel.userId.value,
          fontWeight: FontWeight.w400,
          fontSize: DimensText.captionText(context),
          color: HexColor(ColorVar.bgGray8),
        )),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget trailing,
    Color? titleColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    final double borderRadius = RecipeMateAppUtil.screenWidth * 0.04;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: RecipeMateAppUtil.screenWidth * 0.04, 
          vertical: RecipeMateAppUtil.screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: HexColor(ColorVar.widgetOrCardBgColor).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.01),
              child: Icon(
                icon,
                color: iconColor ?? HexColor(ColorVar.subTextColor),
                size: RecipeMateAppUtil.screenWidth * 0.065,
              ),
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.04),
            Expanded(
              child: customText(
                text: title,
                fontSize: DimensText.bodySmallText(context),
                fontWeight: FontWeight.w600,
                color: titleColor ?? HexColor(ColorVar.black),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}