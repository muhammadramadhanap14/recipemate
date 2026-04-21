import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../../../utils/view_utils/no_data_util.dart';
import '../../../utils/view_utils/view_dialog_util.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final DataSessionUtilController session =
    Get.find<DataSessionUtilController>();

    return ConnectionWrapper(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: customText(
            text: AppLocalizations.of(context)!.stNotification,
            fontSize: DimensText.headerMenusText(context),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => Get.back(),
          ),
        ),
        floatingActionButton: Obx(() {
          if (session.notificationHistory.isEmpty) {
            return const SizedBox();
          }
          return FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.delete),
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
          );
        }),
        body: Obx(() {
          if (session.notificationHistory.isEmpty) {
            return const Center(child: NoDataUtil());
          }
          return ListView.separated(
            padding:
            EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.04),
            itemCount: session.notificationHistory.length,
            separatorBuilder: (context, index) => SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
            itemBuilder: (context, index) {
              final notification = session.notificationHistory[index];
              final DateTime date = DateTime.fromMillisecondsSinceEpoch(notification['timestamp']);
              final String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(date);

              return Dismissible(
                key: Key('${notification['timestamp']}_$index'),
                direction: DismissDirection.horizontal,
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  color: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onPrimary),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onPrimary),
                ),
                onDismissed: (direction) {
                  final removedItem = notification;
                  session.removeNotification(notification);
                  Get.snackbar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                    AppLocalizations.of(context)!.stDeleted,
                    AppLocalizations.of(context)!.stNotificationRemoved,
                    snackPosition: SnackPosition.TOP,
                    mainButton: TextButton(
                      onPressed: () {
                        session.restoreNotification(index, removedItem);
                      },
                      child: Text(
                        "UNDO",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(
                      RecipeMateAppUtil.screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_active,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            customText(
                              text: notification['title'] ?? "",
                              fontSize:
                              DimensText.bodyText(context),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(height: 4),
                            customText(
                              text: notification['body'] ?? "",
                              fontSize: DimensText.bodySmallText(context),
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              intMaxLine: null,
                            ),
                            const SizedBox(height: 8),
                            customText(
                              text: formattedDate,
                              fontSize: DimensText.captionText(context),
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}