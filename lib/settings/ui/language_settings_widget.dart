import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:turing_deal/home/state/app_state_provider.dart';
import 'package:turing_deal/settings/ui/icon_for_language.dart';

class LanguageSettingsWidget extends StatefulWidget{

  const LanguageSettingsWidget({Key? key}) : super(key: key);

  @override
  State<LanguageSettingsWidget> createState() => _LanguageSettingsWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _LanguageSettingsWidgetState extends State<LanguageSettingsWidget> {

  bool expanded = false;
  @override
  Widget build(BuildContext context) {

    AppStateProvider appState = Provider.of<AppStateProvider>(context, listen: false);

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          expanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text('Languages'.tr),
            );
          },
          body: Column(
            children: appState.getPossibleLanguageCodes().map(
                (language) => InkWell(
                  onTap: () => appState.selectLanguage(language).then((value) => appState.refresh()),
                  child: ListTile(
                      title: Text(
                          appState.getLanguageDescription(language),
                          style: appState.getSelectedLanguage() == language ?
                          TextStyle(
                            fontWeight: FontWeight.bold
                          ) : TextStyle(),
                      ),
                      trailing: IconForLanguage(language),
                  ),
                )
            ).toList()
          ),
          isExpanded: expanded,
        )
      ]
    );
  }
}