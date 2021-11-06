import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turing_deal/settings/ui/language_settings_widget.dart';
import 'package:turing_deal/shared/ui/Web.dart';
import 'package:turing_deal/shared/environment.dart';

class SettingsScreen extends StatelessWidget {

  static const String route = 'settings';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: Text('Settings'.tr)
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LanguageSettingsWidget(),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('The objective of this project is to help people to make investment decisions'.tr),
              ),

              SizedBox(height: 10,),

              MaterialButton(
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 10,
                child: Text('Contribute on github'.tr),
                  onPressed: () => Web.launchLink(context, Environment.GITHUB_URL))
            ],
          ),
        ),
      ),
    );
  }
}

