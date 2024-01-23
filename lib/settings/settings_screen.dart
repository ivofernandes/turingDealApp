import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:interactive_i18n/interactive_i18n.dart';
import 'package:provider/provider.dart';
import 'package:td_ui/src/ui/apps_banner.dart';
import 'package:td_ui/td_ui.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/shared/environment.dart';

class SettingsScreen extends StatelessWidget {
  static const String route = 'settings';

  @override
  Widget build(BuildContext context) {
    final AppStateProvider appState = Provider.of<AppStateProvider>(context);
    return SafeArea(
      child: MyScaffold(
        nav: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Expanded(
              child: Text(
                'Settings'.t,
                textAlign: TextAlign.center,
              ),
            ),
            appState.isDark()
                ? IconButton(
                    onPressed: () async {
                      await appState.setIsDark(false);
                      appState.refresh();
                    },
                    icon: const Icon(Icons.light_mode),
                  )
                : IconButton(
                    onPressed: () async {
                      await appState.setIsDark(true);
                      appState.refresh();
                    },
                    icon: const Icon(Icons.dark_mode),
                  )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: InteractiveI18nSelector(
                      onLanguageSelected: (language) {
                        appState.refresh();
                      },
                    ),
                  ),
                  Row(
                    children: [
                      MaterialButton(
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 10,
                        child: Text('Market time'.t),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MarketTimeScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('The objective of this project is to help people to make investment decisions'.t),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 10,
                    child: Text('Contribute on github'.t),
                    onPressed: () => Web.launchLink(context, Environment.githubUrl),
                  ),
                  kIsWeb
                      ? const AppsBanner(
                          playStoreUrl: Environment.playStoreUrl,
                          appStoreUrl: Environment.appStoreUrl,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
