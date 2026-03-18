import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/recipemate_app_util.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: customText(
          text: AppLocalizations.of(context)!.account,
          fontSize: DimensText.headerMenusText(context),
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
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
                icon: Icons.security,
                title: AppLocalizations.of(context)!.security,
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: RecipeMateAppUtil.screenWidth * 0.05,
                ),
                onTap: () => viewModel.navigateToSecurityPage(context),
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
              _buildMenuItem(
                context: context,
                icon: Icons.language,
                title: AppLocalizations.of(context)!.language,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => customText(
                      text: viewModel.currentLanguage.value,
                      fontSize: DimensText.captionText(context),
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                    SizedBox(width: RecipeMateAppUtil.screenWidth * 0.02),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: RecipeMateAppUtil.screenWidth * 0.05,
                    ),
                  ],
                ),
                onTap: () => viewModel.openLanguageDialog(),
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
              _buildMenuItem(
                context: context,
                icon: Icons.dark_mode,
                title: AppLocalizations.of(context)!.theme,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => customText(
                      text: viewModel.currentTheme.value,
                      fontSize: DimensText.captionText(context),
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
                    SizedBox(width: RecipeMateAppUtil.screenWidth * 0.02),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: RecipeMateAppUtil.screenWidth * 0.05,
                    ),
                  ]
                ),
                onTap: () => viewModel.openThemeDialog(context),
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
              _buildMenuItem(
                context: context,
                icon: Icons.change_circle,
                title: AppLocalizations.of(context)!.changeFoodTypes,
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: RecipeMateAppUtil.screenWidth * 0.05,
                ),
                onTap: () => viewModel.openChangePrefFoodDialog(context),
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
              _buildMenuItem(
                context: context,
                icon: Icons.logout_rounded,
                title: AppLocalizations.of(context)!.logout,
                titleColor: Theme.of(context).colorScheme.primary,
                iconColor: Theme.of(context).colorScheme.primary,
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: RecipeMateAppUtil.screenWidth * 0.05,
                ),
                onTap: () => viewModel.openLogoutDialog(context),
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
              child: GestureDetector(
                onTap: () => _showEditPhotoBottomSheet(context),
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

  void _showEditPhotoBottomSheet(BuildContext context) {
    final screenW = RecipeMateAppUtil.screenWidth;
    final screenH = RecipeMateAppUtil.screenHeight;
    final borderRadius = RecipeMateAppUtil.screenWidth * 0.04;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: screenW * 0.06, vertical: screenH * 0.02),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(screenW * 0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: screenW * 0.12,
                height: screenH * 0.006,
              ),
            ),
            SizedBox(height: screenH * 0.03),
            customText(
              text: AppLocalizations.of(context)!.stChangePhoto,
              fontSize: DimensText.bodyText(context),
              fontWeight: FontWeight.bold,
              fontFamily: 'times_new_roman_bold',
              color: Theme.of(context).colorScheme.onSurface,
            ),
            SizedBox(height: screenH * 0.03),
            _buildBottomSheetItem(
              context: context,
              icon: Icons.camera_alt,
              title: AppLocalizations.of(context)!.stTakePhoto,
              onTap: () {
                Get.back();
              },
            ),
            SizedBox(height: screenH * 0.015),
            _buildBottomSheetItem(
              context: context,
              icon: Icons.image,
              title: AppLocalizations.of(context)!.stChoosePhoto,
              onTap: () {
                Get.back();
              },
            ),
            SizedBox(height: screenH * 0.015),
            _buildBottomSheetItem(
              context: context,
              icon: Icons.delete,
              title: AppLocalizations.of(context)!.stRemovPhoto,
              titleColor: Theme.of(context).colorScheme.primary,
              iconColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                Get.back();
              },
            ),
            SizedBox(height: screenH * 0.04),
            SizedBox(
              width: double.infinity,
              child: customElevatedButton(
                onPressed: () => Get.back(),
                text: AppLocalizations.of(context)!.stCancelTitle,
                fontSize: DimensText.buttonSmallText(context),
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.w600,
                backgroundColor: Theme.of(context).cardColor,
                sideColor: Theme.of(context).cardColor,
                fontColor: Theme.of(context).colorScheme.onSurface,
                borderRadius: borderRadius,
              ),
            ),
            SizedBox(height: screenH * 0.02),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildBottomSheetItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    final screenW = RecipeMateAppUtil.screenWidth;
    final borderRadius = RecipeMateAppUtil.screenWidth * 0.04;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: RecipeMateAppUtil.screenHeight * 0.015,
          horizontal: screenW * 0.04,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.onSurface,
              size: screenW * 0.06,
            ),
            SizedBox(width: screenW * 0.04),
            customText(
              text: title,
              fontSize: DimensText.bodySmallText(context),
              fontWeight: FontWeight.w600,
              color: titleColor ?? Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      ),
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
                intMaxLine: null
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}