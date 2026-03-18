import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void show({
    required String title,
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final context = Get.context;

    if (context == null) return;

    final theme = Theme.of(context);

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor:
      backgroundColor ?? theme.colorScheme.primary.withValues(alpha: 0.5),
      colorText: textColor ?? theme.colorScheme.onSurface,
      margin: const EdgeInsets.all(16),
      duration: duration,
    );
  }
}