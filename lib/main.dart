import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:turing_deal/home/home_screen.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/settings/settings_screen.dart';
import 'package:turing_deal/shared/app_theme.dart';

import 'big_picture/state/big_picture_state_provider.dart';

void main() async {
  runApp(TuringDealApp());
}

class TuringDealApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<AppStateProvider>(
            create: (_) => AppStateProvider(),
          ),
          ChangeNotifierProvider<BigPictureStateProvider>(
            create: (_) => BigPictureStateProvider(),
          ),
        ],
        child: Consumer<AppStateProvider>(builder: (context, appState, child) {
          appState.loadData();
          return GetMaterialApp(
              theme: appState.isDark()
                  ? AppTheme.darkTheme()
                  : AppTheme.lightTheme(),
              debugShowCheckedModeBanner: false,
              title: "TuringDeal",
              initialRoute: '/',
              routes: {
                '/': (context) => HomeScreen(),
                SettingsScreen.route: (context) => SettingsScreen(),
              },
              locale: Locale(appState.getSelectedLanguage()),
              translations:
                  TranslationsContainer(translationKeys: appState.getKeys()));
        }));
  }
}

class TranslationsContainer extends Translations {
  final Map<String, Map<String, String>> translationKeys;

  TranslationsContainer({required this.translationKeys});

  @override
  get keys => translationKeys;
}
