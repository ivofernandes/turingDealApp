import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/settings/ui/apps_banner.dart';
import 'package:turing_deal/settings/ui/language_settings_widget.dart';
import 'package:turing_deal/shared/environment.dart';
import 'package:turing_deal/shared/ui/Web.dart';

class SettingsScreen extends StatelessWidget {
  static const String route = 'settings';

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text('Settings'.tr),
          actions: [
            appState.isDark()
                ? IconButton(
                    onPressed: () async {
                      await appState.setIsDark(false);
                      appState.refresh();
                    },
                    icon: Icon(Icons.brightness_5))
                : IconButton(
                    onPressed: () async {
                      await appState.setIsDark(true);
                      appState.refresh();
                    },
                    icon: Icon(Icons.dark_mode))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LanguageSettingsWidget(),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'The objective of this project is to help people to make investment decisions'
                            .tr),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 10,
                      child: Text('Contribute on github'.tr),
                      onPressed: () =>
                          Web.launchLink(context, Environment.GITHUB_URL)),
                  kIsWeb ? AppsBanner() : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
