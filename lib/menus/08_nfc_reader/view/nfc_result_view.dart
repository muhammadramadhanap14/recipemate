import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/utils/dimens_text.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/view_utils/app_snackbar.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import '../view_model/nfc_controller.dart';

class NfcResultView extends StatelessWidget {
  const NfcResultView({super.key});

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
    final NfcController controller = Get.find<NfcController>();
    RecipeMateAppUtil.init(context);
    final theme = Theme.of(context);
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
                top: 380,
                left: -100,
                child: buildBlurBlob(primary.withValues(alpha: 0.2), 360),
              ),
              Positioned(
                bottom: -50,
                right: -50,
                child: buildBlurBlob(primary.withValues(alpha: 0.25), 350),
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
                text: "Scan Result",
                fontSize: DimensText.headerMenusText(context),
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                fontFamily: 'times_new_roman_bold'
            ),
          ),
          body: Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: topReserved + 16,
                bottom: 40,
                left: 20,
                right: 20,
              ),
              child: Obx(() {
                final balance = controller.cardBalance.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),

                    // BADGE STATUS READ SUCCESS
                    _buildSuccessHeaderBadge(context),

                    const SizedBox(height: 24),

                    // WIDGET KARTU RECIPEMATE PREMIUM
                    _buildPremiumGraphicCard(context, controller),

                    const SizedBox(height: 32),

                    // TAMPILAN NOMINAL SALDO
                    customText(
                      text: balance?.formattedSaldo ?? '-',
                      fontSize: DimensText.subHeaderLargeText(context),
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: 'times_new_roman_bold',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    // SUBTITLE BALANCE UPDATED
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        customText(
                          text: 'Balance updated just now',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: primary,
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // TOMBOL AKSI TOP UP & DONE
                    _buildActionButtons(context),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeaderBadge(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primary.withValues(alpha: 0.2),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.3),
                blurRadius: 16,
                spreadRadius: 2,
              )
            ],
          ),
          child: Icon(
            Icons.contactless_rounded,
            color: primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        customText(
          text: 'NFC READ SUCCESS',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
      ],
    );
  }

  Widget _buildPremiumGraphicCard(BuildContext context, NfcController controller) {
    final theme = Theme.of(context);

    return GlassCard(
      settings: _glassSettings(context),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.12),
              Colors.white.withValues(alpha: 0.03),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP ROW: LOGO & CHIP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    customText(
                      text: controller.maskedCardNumber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ],
                ),
                Icon(
                  Icons.contactless_outlined,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                  size: 24,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // BOTTOM ROW: CARDHOLDER & EXPIRES
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: 'CARDHOLDER',
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    const SizedBox(height: 4),
                    customText(
                      text: controller.cardholderName,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(
      children: [
        // TOMBOL TOP UP BALANCE
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            onPressed: () {
              AppSnackbar.show(
                title: 'Top Up Balance',
                message: 'Fitur Top Up bersifat Read-Only dan memerlukan key rahasia enkripsi bank penerbit.',
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_circle_outline_rounded, size: 20),
                const SizedBox(width: 8),
                customText(
                  text: 'Top Up Balance',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // TOMBOL DONE
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              foregroundColor: theme.colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            onPressed: () => Get.back(),
            child: customText(
              text: 'Done',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
