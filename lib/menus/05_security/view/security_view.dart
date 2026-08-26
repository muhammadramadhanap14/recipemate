import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/dimens_text.dart';
import '../view_model/security_view_model.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({super.key});

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
    final SecurityViewModel viewModel = Get.put(
      SecurityViewModel(
        session: Get.find<DataSessionUtilController>(),
      )
    );
    final theme = Theme.of(context);
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
            leading: Padding(
              padding: EdgeInsets.only(
                left: RecipeMateAppUtil.screenWidth * 0.03,
              ),
              child: GlassIconButton(
                onPressed: () => Get.back(),
                size: RecipeMateAppUtil.screenWidth * 0.11,
                iconSize: RecipeMateAppUtil.screenWidth * 0.06,
                shape: GlassIconButtonShape.circle,
                icon: Icon(
                  Icons.keyboard_arrow_left_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                settings: LiquidGlassSettings(
                  glassColor: Theme.of(context).cardColor,
                  backerColor: Colors.black.withValues(alpha: 0.05),
                  thickness: 70,
                  blur: 6,
                  chromaticAberration: 0.35,
                  lightIntensity: 1.2,
                  refractiveIndex: 1.65,
                  ambientRim: 0.3,
                  edgeAbsorption: 0.12,
                ),
              ),
            ),
          title: customText(
            text: AppLocalizations.of(context)!.security,
            fontSize: DimensText.headerMenusText(context),
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            fontFamily: 'times_new_roman_bold',
          ),
            centerTitle: true,
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
                  _buildSectionTitle(AppLocalizations.of(context)!.stBiometric, context),
                  SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
                  GlassGroupedSection(
                    settings: _glassSettings(context),
                    children: [
                      _buildMenuTile(
                        context: context,
                        icon: Icons.fingerprint,
                        title: AppLocalizations.of(context)!.stBiometricFingerPrint,
                        trailing: Obx(() => GlassSwitch(
                          value: viewModel.session.isFingerprintEnabled.value,
                          activeColor: theme.colorScheme.primary,
                          height: 30,
                          width: 65,
                          onChanged: viewModel.toggleFingerprint,
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
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