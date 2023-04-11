import 'package:flutter/material.dart';

class CheckError {
  static void checkErrorState(String? error, BuildContext context) {
    if (error != null) {
      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ),
      );
    }
  }
}
