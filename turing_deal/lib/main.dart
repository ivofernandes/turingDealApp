import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:turing_deal/shared/appTheme.dart';
import 'package:turing_deal/home/state/AppStateProvider.dart';
import 'package:turing_deal/home/homeScreen.dart';

import 'bigPicture/state/BigPictureStateProvider.dart';

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