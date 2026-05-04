import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recipemate/l10n/app_localizations.dart';
import 'package:recipemate/menus/07_chat/view/view_model/chat_view_model.dart';
import 'package:recipemate/menus/08_chat_session/view/view_model/chat_history_controller.dart';
import 'package:recipemate/models/model/chat_session.dart';
import 'package:recipemate/models/model/chat_message.dart';
import 'package:recipemate/utils/dimens_text.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';
import 'package:recipemate/utils/view_utils/no_data_util.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.session, super.key});

  final ChatSession session;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final ChatViewModel controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ChatViewModel(session: widget.session),
      tag: widget.session.id,
    );
  }

  late final inputController = TextEditingController();

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyController = Get.find<ChatHistoryController>();

    return ConnectionWrapper(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: _buildDrawer(context, historyController),
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[controller.messages.length - 1 - index];
                    // FIX: Removed Obx from here to avoid "improper use" error for non-reactive messages.
                    // Sub-components will use Obx for their specific reactive parts.
                    return msg.isUser
                        ? _buildUserMessage(context, msg)
                        : _buildAiMessage(context, msg);
                  },
                ),
              ),
            ),

            /// START COOKING BUTTON (IF READY)
            Obx(() {
              if (!controller.isReady.value || controller.isCooking.value) {
                return const SizedBox();
              }
              return _buildStartCookingCard(context);
            }),

            /// BOTTOM NAVIGATION (DURING COOKING)
            Obx(() {
              if (!controller.isCooking.value) return const SizedBox();
              return _buildCookingNavigation(context);
            }),

            /// INPUT FIELD
            _buildInputField(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: colorScheme.onSurface),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: customText(
        text: "RecipeMate",
        fontSize: DimensText.headerMenusText(context),
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
        fontFamily: 'times_new_roman_bold',
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, ChatHistoryController historyController) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width * 0.75,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: customText(
                text: AppLocalizations.of(context)!.stHistoryChat,
                fontSize: DimensText.headerMenusText(context),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: 'times_new_roman_bold',
              ),
            ),
            Expanded(
              child: Obx(() {
                if (historyController.sessions.isEmpty) {
                  return const Center(child: NoDataUtil());
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: historyController.sessions.length,
                  itemBuilder: (context, index) {
                    final session = historyController.sessions[index];
                    return ListTile(
                      title: customText(
                        text: session.title,
                        fontSize: DimensText.bodyText(context),
                        color: colorScheme.onSurface,
                        intMaxLine: null
                      ),
                      subtitle: customText(
                        text: DateFormat('dd MMM yyyy').format(session.createdAt),
                        fontSize: DimensText.captionText(context),
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.offNamed('/chat', arguments: session, preventDuplicates: false);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiMessage(BuildContext context, ChatMessage msg) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome, color: colorScheme.onPrimary, size: 14),
              ),
              const SizedBox(width: 8),
              customText(
                text: "RECIPEMATE AI",
                fontSize: DimensText.captionText(context),
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownBody(
                  data: msg.text,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      fontSize: DimensText.bodyText(context),
                      color: colorScheme.onSurface,
                      fontFamily: 'Poppins-Regular',
                    ),
                    strong: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // Reactive Timer Card
                Obx(() {
                  bool isCurrentStep = controller.isCooking.value && 
                      controller.steps.isNotEmpty &&
                      controller.currentStep.value < controller.steps.length &&
                      controller.steps[controller.currentStep.value] == msg.text;
                  
                  if (isCurrentStep && controller.extractTimeInSeconds(msg.text) > 0) {
                    return _buildTimerCard(context, msg.text);
                  }
                  return const SizedBox.shrink();
                }),
                
                if (msg.options != null && msg.options!.isNotEmpty) 
                  _buildQuickReplies(context, msg.options!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(BuildContext context, ChatMessage msg) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: customText(
              text: msg.text,
              fontSize: DimensText.bodyText(context),
              color: colorScheme.onSurface,
              intMaxLine: null,
            ),
          ),
          const SizedBox(height: 4),
          customText(
            text: "SENT ${DateFormat('hh:mm a').format(msg.timestamp)}",
            fontSize: DimensText.captionText(context),
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard(BuildContext context, String step) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
          )
        ]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer, color: colorScheme.primary, size: 18),
              const SizedBox(width: 8),
              customText(
                text: controller.recipeName.value.toUpperCase(),
                fontSize: DimensText.captionText(context),
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Reaktif terhadap ticking timer
          Obx(() {
            final seconds = controller.remainingSeconds.value;
            final minutes = seconds ~/ 60;
            final secs = seconds % 60;
            return customText(
              text: "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}",
              fontSize: DimensText.superHeaderText(context),
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
              fontFamily: 'Serif',
            );
          }),
          
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Obx(() => customRawMaterialButton(
                  onPressed: () => controller.toggleTimerFromStep(step),
                  backgroundColor: colorScheme.primary,
                  fontColor: colorScheme.onPrimary,
                  text: controller.isTimerRunning.value ? "PAUSE" : "RESUME",
                  fontWeight: FontWeight.bold,
                  douHeight: 45,
                  douWidth: double.infinity,
                  borderRadius: 30,
                )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: customOutlinedButton(
                  onPressed: () => controller.updateTimerForStep(step),
                  borderColor: colorScheme.primary,
                  fontColor: colorScheme.primary,
                  text: "STOP",
                  fontWeight: FontWeight.bold,
                  borderRadius: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplies(BuildContext context, List<String> options) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((opt) {
          return ActionChip(
            label: customText(
              text: opt,
              color: colorScheme.onPrimary,
              fontSize: DimensText.bodySmallText(context),
            ),
            onPressed: () => controller.sendMessage(opt),
            backgroundColor: colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStartCookingCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          customText(
            text: "Ready to start cooking?",
            fontWeight: FontWeight.bold,
            fontSize: DimensText.bodyText(context),
            color: colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          customRawMaterialButton(
            onPressed: controller.startCooking,
            backgroundColor: colorScheme.primary,
            fontColor: colorScheme.onPrimary,
            text: "START COOKING",
            fontSize: DimensText.bodySmallText(context),
            fontWeight: FontWeight.bold,
            douHeight: 40,
            douWidth: double.infinity,
            borderRadius: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildCookingNavigation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextButton(
            onPressed: controller.prevStep,
            icon: Icon(Icons.chevron_left, color: colorScheme.primary),
            text: "PREVIOUS",
            fontSize: DimensText.bodySmallText(context),
            fontWeight: FontWeight.bold,
            fontColor: colorScheme.primary,
          ),
          customElevatedButton(
            onPressed: controller.nextStep,
            text: "NEXT STEP",
            fontSize: DimensText.bodySmallText(context),
            icon: Icon(Icons.chevron_right, color: colorScheme.onPrimary),
            backgroundColor: colorScheme.primary,
            fontColor: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            borderRadius: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.add, color: colorScheme.onSurface),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: inputController,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontFamily: 'Poppins-Regular'
                ),
                decoration: InputDecoration(
                  hintText: "Ask about the next step...",
                  hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (inputController.text.isNotEmpty) {
                controller.sendMessage(inputController.text);
                inputController.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: colorScheme.onPrimary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}