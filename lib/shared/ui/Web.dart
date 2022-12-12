import 'package:flutter/material.dart';
import 'package:turing_deal/shared/ui/UIUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class Web {
  static void launchLink(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      UIUtils.snackBarError('Error on trying to open url');
    }
  }
}
