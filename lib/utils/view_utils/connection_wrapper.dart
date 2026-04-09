import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipemate/utils/recipemate_app_util.dart';
import 'package:recipemate/utils/view_utils/primary_global_view.dart';
import '../../l10n/app_localizations.dart';
import '../dimens_text.dart';

class ConnectionWrapper extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onRestart;

  const ConnectionWrapper({
    super.key,
    required this.child,
    this.onRestart,
  });

  @override
  State<ConnectionWrapper> createState() => _ConnectionWrapperState();
}

class _ConnectionWrapperState extends State<ConnectionWrapper> {
  final RxBool isLoading = true.obs;
  final RxBool hasConnection = true.obs;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    hasConnection.value = await RecipeMateAppUtil.checkConnection();
    isLoading.value = false;
  }

  Future<void> _retryConnection() async {
    isLoading.value = true;
    hasConnection.value = await RecipeMateAppUtil.checkConnection();
    if (hasConnection.value && widget.onRestart != null) {
      await widget.onRestart!();
    }
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      }

      if (!hasConnection.value) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  customText(
                    text: AppLocalizations.of(context)!.stNoConnectionInternetTitle,
                    fontSize: DimensText.headerText(context),
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  customText(
                    text: AppLocalizations.of(context)!.stNoConnectionInternetMessage,
                    fontSize: DimensText.captionText(context),
                    color: Theme.of(context).colorScheme.onSurface,
                    textAlign: TextAlign.center,
                    intMaxLine: 2,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 200,
                    child: customElevatedButton(
                      onPressed: _retryConnection,
                      text: AppLocalizations.of(context)!.stRetryBtn,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      fontColor: Theme.of(context).colorScheme.onError,
                      borderRadius: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return widget.child;
    });
  }
}