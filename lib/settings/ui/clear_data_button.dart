import 'package:app_dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';

class ClearDataButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BigPictureStateProvider bigPictureState = Provider.of<BigPictureStateProvider>(context, listen: false);
    return MaterialButton(
      color: Theme.of(context).colorScheme.error,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      child: Text('Clear data'.t),
      onPressed: () {
        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: Text('Confirm'.t),
            content: Text('Are you sure you want to clear all data?'.t),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'.t),
                onPressed: () {
                  // Close the dialog
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: Text('Clear'.t),
                onPressed: () {
                  // Clear all data
                  bigPictureState.removeAll();
                  // Close the dialog
                  Navigator.of(dialogContext).pop();
                  // Optionally, add feedback to the user (e.g., a snackbar) to confirm the data has been cleared
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
