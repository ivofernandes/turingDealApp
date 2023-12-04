import 'package:flutter/material.dart';
import 'package:td_ui/src/shared/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Web {
  static Future<void> launchLink(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      UIUtils.snackBarError('Error on trying to open url');
    }
  }
}
