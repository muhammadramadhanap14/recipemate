import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constant_var.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/account_view_model.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountViewModel viewModel = Get.put(AccountViewModel());
    final theme = Theme.of(context);
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: true,
        title: customText(
          text: ConstantVar.akun,
          fontSize: DimensText.headerMenusText(context),
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down, 
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                title: "Theme",
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: RecipeMateAppUtil.screenWidth * 0.05,
                ),
                onTap: () => viewModel.openThemeDialog(context),
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
              _buildMenuItem(
                context: context,
                icon: Icons.logout_rounded,
                title: "Logout",
                titleColor: Theme.of(context).colorScheme.primary,
                iconColor: Theme.of(context).colorScheme.primary,
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: RecipeMateAppUtil.screenWidth * 0.05,
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
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: RecipeMateAppUtil.screenWidth * 0.005,
                  ),
                ),
                child: Icon(
                  Icons.edit, 
                  color: Theme.of(context).colorScheme.onPrimary,
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
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: 'times_new_roman_bold'
        )),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.002),
        Obx(() => customText(
          text: viewModel.userId.value,
          fontWeight: FontWeight.w400,
          fontSize: DimensText.captionText(context),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.01),
              child: Icon(
                icon,
                color: iconColor ?? Theme.of(context).colorScheme.onSurface,
                size: RecipeMateAppUtil.screenWidth * 0.065,
              ),
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.04),
            Expanded(
              child: customText(
                text: title,
                fontSize: DimensText.bodySmallText(context),
                fontWeight: FontWeight.w600,
                color: titleColor ?? Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}