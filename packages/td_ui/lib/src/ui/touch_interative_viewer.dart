import 'package:flutter/material.dart';
import 'package:td_ui/src/app_theme.dart';

/// Puts stuff in interactive viewer unless we are in web desktop
class TouchInteractiveViewer extends StatelessWidget {
  final Widget child;

  const TouchInteractiveViewer({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (AppTheme.isDesktopWeb()) {
      return child;
    } else {
      return InteractiveViewer(child: child);
    }
  }
}
