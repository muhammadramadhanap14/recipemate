import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';

import '../../../utils/data_session_util_controller.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/no_notification_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final DataSessionUtilController session = Get.find<DataSessionUtilController>();
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
                top: -80,
                right: -80,
                child: buildBlurBlob(
                  primary.withValues(alpha: 0.35),
                  420,
                ),
              ),
              Positioned(
                top: 380,
                left: -140,
                child: buildBlurBlob(
                  primary.withValues(alpha: 0.22),
                  380,
                ),
              ),
              Positioned(
                bottom: 40,
                right: -120,
                child: buildBlurBlob(
                  primary.withValues(alpha: 0.28),
                  400,
                ),
              ),
            ],
          ),
          appBar: GlassAppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: Padding(
              padding: EdgeInsets.only(left: RecipeMateAppUtil.screenWidth * 0.03),
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
              text: AppLocalizations.of(context)!.stNotification,
              fontSize: DimensText.headerMenusText(context),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: 'times_new_roman_bold',
            ),
          ),

          body: SafeArea(
            child: Obx(() {
              final double topReserved = MediaQuery.of(context).padding.top + 44.0;
              if (session.notificationHistory.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: topReserved),
                  child: const Center(
                    child: NoNotificationUtil(),
                  ),
                );
              }
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  RecipeMateAppUtil.screenWidth * 0.05,
                  topReserved,
                  RecipeMateAppUtil.screenWidth * 0.05,
                  RecipeMateAppUtil.screenHeight * 0.13,
                ),
                itemCount: session.notificationHistory.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015);
                },

                itemBuilder: (context, index) {
                  final notification = session.notificationHistory[index];
                  final DateTime date = DateTime.fromMillisecondsSinceEpoch(notification['timestamp']);
                  final String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(date);

                  return Dismissible(
                    key: Key('${notification['timestamp']}_$index'),
                    direction: DismissDirection.horizontal,
                    background: _buildDismissBackground(
                      context,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 24),
                    ),
                    secondaryBackground: _buildDismissBackground(
                      context,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                    ),
                    onDismissed: (direction) {
                      final removedItem = notification;
                      session.removeNotification(notification);
                      Get.snackbar(
                        AppLocalizations.of(context)!.stDeleted,
                        AppLocalizations.of(context)!.stNotificationRemoved,
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.75),
                        colorText: Theme.of(context).colorScheme.onPrimary,
                        snackPosition: SnackPosition.TOP,
                        margin: EdgeInsets.all(
                          RecipeMateAppUtil.screenWidth * 0.04,
                        ),
                        borderRadius: 16,
                        mainButton: TextButton(
                          onPressed: () {
                            session.restoreNotification(
                              index,
                              removedItem,
                            );
                          },
                          child: customText(
                            text: 'UNDO',
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    child: _buildNotificationCard(
                      context,
                      notification,
                      formattedDate,
                    ),
                  );
                },
              );
            }),
          ),
          bodyOverlays: [
            Positioned(
              right: RecipeMateAppUtil.screenWidth * 0.05,
              bottom: RecipeMateAppUtil.screenHeight * 0.03,
              child: Obx(() {
                if (session.notificationHistory.isEmpty) {
                  return const SizedBox.shrink();
                }
                return GlassIconButton(
                  onPressed: () {
                    ViewDialogUtil().showConfirmDialog(
                      title: AppLocalizations.of(context)!.stDeleteAll,
                      icon: Icons.question_mark,
                      context: context,
                      message: AppLocalizations.of(context)!.stDeleteAllMessage,
                      positiveTitle: AppLocalizations.of(context)!.yesBtn,
                      negativeTitle: AppLocalizations.of(context)!.stCancelTitle,
                      onPositiveClick: () async {
                        session.clearNotifications();
                        Get.back();
                      },
                    );
                  },
                  size: RecipeMateAppUtil.screenWidth * 0.14,
                  iconSize: RecipeMateAppUtil.screenWidth * 0.06,
                  shape: GlassIconButtonShape.circle,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color:
                    Theme.of(context).colorScheme.primary,
                  ),
                  settings: LiquidGlassSettings(
                    glassColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
                    backerColor: Colors.black.withValues(alpha: 0.05),
                    thickness: 90,
                    blur: 8,
                    chromaticAberration: 0.35,
                    lightIntensity: 1.25,
                    refractiveIndex: 1.68,
                    ambientRim: 0.3,
                    edgeAbsorption: 0.12,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissBackground(BuildContext context, {
    required Alignment alignment,
    required EdgeInsets padding
    }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.045),
      child: Container(
        alignment: alignment,
        padding: padding,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.045),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
          size: RecipeMateAppUtil.screenWidth * 0.065,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, dynamic notification, String formattedDate) {
    final double borderRadius = RecipeMateAppUtil.screenWidth * 0.045;
    return GlassCard(
      padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.04),
      shape: LiquidRoundedRectangle(borderRadius: borderRadius),
      settings: LiquidGlassSettings(
        glassColor: Theme.of(context).cardColor,
        backerColor: Colors.black.withValues(alpha: 0.05),
        thickness: 100,
        blur: 8,
        chromaticAberration: 0.4,
        lightIntensity: 1.2,
        refractiveIndex: 1.68,
        ambientRim: 0.3,
        edgeAbsorption: 0.12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            padding: const EdgeInsets.all(9),
            shape: const LiquidRoundedRectangle(borderRadius: 100),
            settings: LiquidGlassSettings(
              glassColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.16),
              backerColor: Colors.black.withValues(alpha: 0.02),
              thickness: 60,
              blur: 5,
              chromaticAberration: 0.2,
              lightIntensity: 1.1,
              refractiveIndex: 1.6,
              ambientRim: 0.2,
              edgeAbsorption: 0.1,
            ),
            child: Icon(
              Icons.notifications_active_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: RecipeMateAppUtil.screenWidth * 0.06,
            ),
          ),
          SizedBox(width: RecipeMateAppUtil.screenWidth * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: notification['title'] ?? '',
                  fontSize: DimensText.bodyText(context),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(height: 5),
                customText(
                  text: notification['body'] ?? '',
                  fontSize: DimensText.bodySmallText(context),
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  intMaxLine: null,
                ),
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.012),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: RecipeMateAppUtil.screenWidth * 0.035,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: customText(
                        text: formattedDate,
                        fontSize: DimensText.captionText(context,),
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}