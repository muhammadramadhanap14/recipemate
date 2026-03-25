import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/menus/07_security/view_model/security_view_model.dart';
import 'package:recipemate/utils/data_session_util.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/dimens_text.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    final SecurityViewModel viewModel = Get.put(
      SecurityViewModel(
        dataSessionUtil: Get.find<DataSessionUtil>()
    ));
    final theme = Theme.of(context);
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    return ConnectionWrapper(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left, color: theme.colorScheme.onSurface),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: customText(
            text: AppLocalizations.of(context)!.security,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
                _buildProfileHeader(context, viewModel),
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.04),

                _buildSectionTitle(AppLocalizations.of(context)!.stBiometric, context),
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
                _buildMenuItem(
                  context: context,
                  icon: Icons.fingerprint,
                  title: AppLocalizations.of(context)!.stBiometricFingerPrint,
                  trailing: Obx(() => Switch(
                    value: viewModel.isFingerprintEnabled.value,
                    activeThumbColor: theme.colorScheme.primary,
                    onChanged: viewModel.toggleFingerprint,
                  )),
                ),
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.04),

                _buildSectionTitle(AppLocalizations.of(context)!.stPasswordManagement, context),
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
                _buildMenuItem(
                  context: context,
                  icon: Icons.history,
                  title: AppLocalizations.of(context)!.stChangePassword,
                  trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                  onTap: () {},
                ),
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return customText(
      text: title,
      fontSize: DimensText.bodyText(context),
      fontWeight: FontWeight.bold,
      fontFamily: 'times_new_roman_bold',
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  Widget _buildProfileHeader(BuildContext context, SecurityViewModel viewModel) {
    final double profileSize = RecipeMateAppUtil.screenWidth * 0.28;

    return Center(
      child: Column(
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
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final borderRadius = RecipeMateAppUtil.screenWidth * 0.04;

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
                color: Theme.of(context).colorScheme.onSurface,
                size: RecipeMateAppUtil.screenWidth * 0.065,
              ),
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: title,
                    fontSize: DimensText.bodySmallText(context),
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: RecipeMateAppUtil.screenHeight * 0.002),
                    customText(
                      text: subtitle,
                      fontSize: DimensText.microText(context),
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}