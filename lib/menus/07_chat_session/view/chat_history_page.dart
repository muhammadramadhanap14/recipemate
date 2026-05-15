import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/menus/07_chat_session/view/view_model/chat_history_controller.dart';
import 'package:recipemate/utils/view_utils/no_data_util.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  late final ChatHistoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ChatHistoryController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: customText(
          text: AppLocalizations.of(context)!.stHistoryChat,
          fontSize: DimensText.headerMenusText(context),
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: 'times_new_roman_bold',
        ),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final session = controller.createNewSession();

          Get.toNamed('/chat', arguments: session);
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.sessions.isEmpty) {
          return const Center(child: NoDataUtil());
        }

        return ListView.builder(
          itemCount: controller.sessions.length,
          itemBuilder: (context, index) {
            final session = controller.sessions[index];

            return ListTile(
              title: customText(
                text: session.title,
                fontSize: DimensText.bodyText(context),
                color: Theme.of(context).colorScheme.onSurface,
                intMaxLine: null
              ),
              subtitle: customText(
                text: session.createdAt.toString(),
                fontSize: DimensText.bodySmallText(context),
                color: Theme.of(context).colorScheme.onSurface,
                intMaxLine: null
              ),
              onTap: () {
                Get.toNamed('/chat', arguments: session);
              },
            );
          },
        );
      }),
    );
  }
}
