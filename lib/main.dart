import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:turing_deal/shared/app_theme.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/home/home_screen.dart';

import 'bigPicture/state/big_picture_state_provider.dart';

void main() {
  runApp(TuringDealApp());
}

class TuringDealApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<AppStateProvider>(
            create: (_) => AppStateProvider(context),
          ),
          ChangeNotifierProvider<BigPictureStateProvider>(
            create: (_) => BigPictureStateProvider(context),
          ),
        ],
        child: Consumer<AppStateProvider>(
          builder: (context, appState, child) {
            appState.loadData();
            return GetMaterialApp(
                theme: AppTheme.darkTheme(),
                debugShowCheckedModeBanner: false,
                title: "TuringDeal",
                home: HomeScreen()
            );
        })
    );
  }
}