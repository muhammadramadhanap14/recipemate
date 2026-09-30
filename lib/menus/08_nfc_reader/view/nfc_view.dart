import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/utils/dimens_text.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import '../view_model/nfc_controller.dart';

class NfcView extends StatelessWidget {
  const NfcView({super.key});

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
    final NfcController controller = Get.put(NfcController());
    RecipeMateAppUtil.init(context);

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
            title: customText(
              text: 'NFC Balance',
              fontSize: DimensText.headerMenusText(context),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
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
                final isScanning = controller.isScanning.value;
                final error = controller.errorMessage.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    customText(
                      text: isScanning ? 'Scanning Card...' : 'Ready to Scan',
                      fontSize: DimensText.subHeaderLargeText(context),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: 'times_new_roman_bold',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: customText(
                        text: 'Hold your recipe card against the back of your phone.',
                        fontSize: DimensText.bodySmallText(context),
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        textAlign: TextAlign.center,
                        intMaxLine: 2,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ILUSTRASI EFEK RIPPLE GELOMBANG NFC
                    _buildNfcRippleIllustration(context, isScanning),

                    const SizedBox(height: 36),

                    // CHIP STATUS
                    _buildStatusPill(context, isScanning),

                    if (error != null && error.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildErrorBanner(context, error),
                    ],

                    const SizedBox(height: 40),

                    _buildScanButton(context, controller, isScanning),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNfcRippleIllustration(BuildContext context, bool isScanning) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isScanning
                      ? primary.withValues(alpha: 0.35)
                      : primary.withValues(alpha: 0.1),
                  width: 1.5,
                ),
              ),
            ),
            // Gelombang Ring 2
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isScanning
                      ? primary.withValues(alpha: 0.5)
                      : primary.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
            ),
            // Gelombang Ring 1 (Terdalam)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isScanning
                    ? primary.withValues(alpha: 0.15)
                    : primary.withValues(alpha: 0.05),
                border: Border.all(
                  color: primary.withValues(alpha: isScanning ? 0.6 : 0.25),
                  width: 2,
                ),
              ),
            ),
            // ILUSTRASI PHONE & TARGET NFC
            GlassCard(
              settings: _glassSettings(context),
              child: Container(
                width: 110,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withValues(alpha: 0.4),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.6),
                        ),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF10B981),
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 28,
                      height: 4,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context, bool isScanning) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isScanning ? const Color(0xFF10B981) : theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          customText(
            text: isScanning ? 'Recipe Card Detected' : 'Siap Membaca Kartu',
            fontSize: DimensText.bodySmallText(context),
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, String errorMessage) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: errorColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: errorColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: customText(
              text: errorMessage,
              fontSize: 13,
              color: errorColor,
              fontWeight: FontWeight.w500,
              intMaxLine: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton(BuildContext context, NfcController controller, bool isScanning) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 2,
        ),
        onPressed: isScanning ? null : () => controller.scanCard(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isScanning ? Icons.sync_rounded : Icons.contactless_rounded),
            const SizedBox(width: 10),
            customText(
              text: isScanning ? 'Memindai Kartu...' : 'Scan Kartu Sekarang',
              fontSize: DimensText.buttonMediumText(context),
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}