import 'package:flutter/material.dart';

class MyAppContext {
  static final globalNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'app_navigator');

  static BuildContext context = globalNavigatorKey.currentContext!;
}
