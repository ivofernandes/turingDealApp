import 'package:flutter/material.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';

/// Puts stuff in interactive viewer unless we are in web desktop
class TouchInteractiveViewer extends StatelessWidget {
  final Widget child;

  const TouchInteractiveViewer({required this.child});

  @override
  Widget build(BuildContext context) {
    if (AppStateProvider.isDesktopWeb()) {
      return child;
    } else {
      return InteractiveViewer(child: child);
    }
  }
}
