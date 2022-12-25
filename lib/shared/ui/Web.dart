import 'package:flutter/material.dart';
import 'package:turing_deal/shared/ui/UIUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class Web {
  static Future<void> launchLink(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      UIUtils.snackBarError('Error on trying to open url');
    }
  }
}
