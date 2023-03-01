import 'package:flutter/material.dart';
import 'package:td_ui/td_ui.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:turing_deal/shared/my_app_context.dart';

class UIUtils {
  static void bottomSheet(
    Widget bottomSheet, {
    BuildContext? contextParam,
  }) {
    final BuildContext context = contextParam ?? MyAppContext.globalNavigatorKey.currentContext!;

    showModalBottomSheet(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      builder: (context) => bottomSheet,
    );
  }

  static void snackBarError(String message, {BuildContext? contextParam}) {
    final BuildContext context = contextParam ?? MyAppContext.context;

    UIUtils.show(
      context: context,
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppTheme.error,
            ),
      ),
    );
  }

  static void show({
    required BuildContext context,
    required Widget content,
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    showTopSnackBar(
      Overlay.of(context),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: content,
          ),
        ],
      ),
      displayDuration: duration,
    );
  }
}
