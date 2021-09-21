import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:turing_deal/shared/appTheme.dart';
import 'package:turing_deal/home/state/AppStateProvider.dart';
import 'package:turing_deal/home/homeScreen.dart';

void main() {
  runApp(TuringDealApp());
}

class TuringDealApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AppStateProvider(context),
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
