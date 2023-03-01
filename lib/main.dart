import 'package:flutter/material.dart';
import 'package:interactive_i18n/interactive_i18n.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:td_ui/td_ui.dart';
import 'package:turing_deal/big_picture/state/big_picture_state_provider.dart';
import 'package:turing_deal/home/home_screen.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/settings/settings_screen.dart';
import 'package:turing_deal/shared/my_app_context.dart';

void main() async {
  runApp(TuringDealApp());
}

class TuringDealApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<AppStateProvider>(
            create: (_) => AppStateProvider(),
          ),
          ChangeNotifierProvider<BigPictureStateProvider>(
            create: (_) => BigPictureStateProvider(),
          ),
        ],
        child: Consumer<AppStateProvider>(
          builder: (context, appState, child) {
            appState.loadData();
            return InteractiveLocalization(
              availableLanguages: const ['en', 'pt'],
              languageUpdated: () => appState.refresh(),
              child: MaterialApp(
                navigatorKey: MyAppContext.globalNavigatorKey,
                theme: appState.isDark() ? AppTheme.darkTheme() : AppTheme.lightTheme(),
                debugShowCheckedModeBanner: false,
                title: 'TuringDeal',
                initialRoute: '/',
                routes: {
                  '/': (context) => HomeScreen(
                        key: UniqueKey(),
                      ),
                  SettingsScreen.route: (context) => SettingsScreen(),
                },
              ),
            );
          },
        ),
      );
}
