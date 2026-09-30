import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/account_view_model.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  static LiquidGlassSettings _glassSettings(BuildContext context, {double backerAlpha = 0.06}) {
    return LiquidGlassSettings(
      glassColor: Theme.of(context).cardColor,
      backerColor: Colors.black.withValues(alpha: backerAlpha),
      thickness: 100,
      blur: 8,
      chromaticAberration: 0.4,
      lightIntensity: 1.2,
      refractiveIndex: 1.68,
      saturation: 1.1,
      ambientStrength: 1.1,
      ambientRim: 0.3,
      edgeAbsorption: 0.12,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AccountViewModel viewModel = Get.put(
      AccountViewModel(
        session: Get.find<DataSessionUtilController>(),
      )
    );
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    final double topReserved = MediaQuery.of(context).padding.top + kToolbarHeight;
    final primary = Theme.of(context).colorScheme.primary;

    return ConnectionWrapper(
      child: Material(
        color: Colors.transparent,
        child: GlassScaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          edgeToEdge: true,
          extendBody: true,
          edgeFade: false,
          background: Stack(
            children: [
              Container(color: Theme.of(context).scaffoldBackgroundColor),
              Positioned(
                top: -60,
                right: -60,
                child: buildBlurBlob(primary.withValues(alpha: 0.35), 400),
              ),
              Positioned(
                top: 420,
                left: -120,
                child: buildBlurBlob(primary.withValues(alpha: 0.22), 380),
              ),
              Positioned(
                bottom: -60,
                right: -80,
                child: buildBlurBlob(primary.withValues(alpha: 0.28), 380),
              ),
            ],
          ),
          appBar: GlassAppBar(
            backgroundColor: Colors.transparent,
            title: customText(
              text: AppLocalizations.of(context)!.account,
              fontSize: DimensText.headerMenusText(context),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: 'times_new_roman_bold',
            ),
          ),
          body: Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: RecipeMateAppUtil.screenWidth * 0.01,
                ),
                child: Column(
                  children: [
                    SizedBox(height: topReserved + RecipeMateAppUtil.screenHeight * 0.02),
                    _buildProfileHeader(context, viewModel),
                    SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
                    GlassGroupedSection(
                      settings: _glassSettings(context),
                      children: [
                        _buildMenuTile(
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
                        _buildMenuTile(
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
                        _buildMenuTile(
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
                            ],
                          ),
                          onTap: () => viewModel.openThemeDialog(context),
                        ),
                        _buildMenuTile(
                          context: context,
                          icon: Icons.logout_rounded,
                          title: AppLocalizations.of(context)!.logout,
                          titleColor: Theme.of(context).colorScheme.primary,
                          iconColor: Theme.of(context).colorScheme.primary,
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Theme.of(context).colorScheme.primary,
                            size: RecipeMateAppUtil.screenWidth * 0.05,
                          ),
                          onTap: () => viewModel.openLogoutDialog(context),
                        ),
                      ],
                    ),

                    SizedBox(height: RecipeMateAppUtil.screenHeight * 0.06),
                    Obx(() => Center(
                      child: customText(
                        text: viewModel.appVersion.value,
                        fontSize: DimensText.captionText(context),
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                    SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
        )
      ));
  }

  Widget _buildProfileHeader(BuildContext context, AccountViewModel viewModel) {
    final double profileSize = RecipeMateAppUtil.screenWidth * 0.35;

    return Column(
      children: [
        Stack(
          children: [
            Obx(() => Container(
              width: profileSize,
              height: profileSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                  width: RecipeMateAppUtil.screenWidth * 0.01,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: viewModel.session.profileImage.value != null
                    ? FileImage(viewModel.session.profileImage.value!)
                    : const AssetImage("assets/images/profile_pict_icon.png") as ImageProvider,
                backgroundColor: Colors.transparent,
              ),
            )),
            Positioned(
              bottom: RecipeMateAppUtil.screenWidth * 0.01,
              right: RecipeMateAppUtil.screenWidth * 0.01,
              child: GestureDetector(
                onTap: () => _showEditPhotoBottomSheet(context, viewModel),
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
            text: viewModel.fullName.value,
            fontSize: DimensText.subHeaderLargeText(context),
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'times_new_roman_bold',
            intMaxLine: null,
            textAlign: TextAlign.center
        )),
        SizedBox(height: RecipeMateAppUtil.screenHeight * 0.005),
        Obx(() => customText(
            text: viewModel.emailId.value,
            fontWeight: FontWeight.w400,
            fontSize: DimensText.captionText(context),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            textAlign: TextAlign.center,
            intMaxLine: null
        )),
      ],
    );
  }

  void _showEditPhotoBottomSheet(BuildContext context, AccountViewModel viewModel) {
    final screenW = RecipeMateAppUtil.screenWidth;
    final screenH = RecipeMateAppUtil.screenHeight;
    final borderRadius = RecipeMateAppUtil.screenWidth * 0.04;

    Get.bottomSheet(
      GlassSheet(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.06,
            vertical: screenH * 0.02,
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: screenW * 0.12,
                    height: screenH * 0.006,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                    viewModel.pickImage(ImageSource.camera);
                  },
                ),
                SizedBox(height: screenH * 0.015),
                _buildBottomSheetItem(
                  context: context,
                  icon: Icons.image,
                  title: AppLocalizations.of(context)!.stChoosePhoto,
                  onTap: () {
                    Get.back();
                    viewModel.pickImage(ImageSource.gallery);
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
                    viewModel.removeImage();
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
      child: GlassCard(
        padding: EdgeInsets.zero,
        shape: LiquidRoundedRectangle(borderRadius: borderRadius),
        settings: _glassSettings(context, backerAlpha: 0.08),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: RecipeMateAppUtil.screenHeight * 0.015,
            horizontal: screenW * 0.04,
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
      ),
    );
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget trailing,
    Color? titleColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return CupertinoListTile(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: RecipeMateAppUtil.screenWidth * 0.04,
        vertical: RecipeMateAppUtil.screenHeight * 0.025,
      ),
      leading: Icon(
        icon, color: iconColor ?? Theme.of(context).colorScheme.onSurface,
        size: RecipeMateAppUtil.screenWidth * 0.065,
      ),
      title: customText(
        text: title,
        fontSize: DimensText.bodySmallText(context),
        fontWeight: FontWeight.w600,
        color: titleColor ?? Theme.of(context).colorScheme.onSurface,
        intMaxLine: null,
      ),
      trailing: trailing,
    );
  }
}