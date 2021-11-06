import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin LanguageState {

  static const Map<String, String> languages = {
    'en': 'English',
    'pt': 'Português'
  };

  String selectedLanguage = 'en';
  Map<String, Map<String, String>> keys = {
    'en': {
      'Settings': 'test'
    }
  };

  List<String> getPossibleLanguageCodes(){
    return languages.keys.toList();
  }

  String getLanguageDescription(String code){
    return languages[code]!;
  }

  Future<void> loadUserLanguage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? currentLanguageString = prefs.getString('current_language');

    if(currentLanguageString != null){
      await selectLanguage(currentLanguageString);
    }else{
      await selectLanguage(deviceLocale());
    }
  }

  String deviceLocale() {
    String deviceLocale = 'en';

    if (!kIsWeb) {
      final String defaultLocale = Platform.localeName;
      deviceLocale = defaultLocale.substring(0, 2);
    }

    print('device locales: ' + deviceLocale);

    return deviceLocale;
  }

  Future<void> selectLanguage(String language) async{
    selectedLanguage = language;

    keys = await loadKeys(selectedLanguage);


    Get.clearTranslations();
    Get.addTranslations(keys);
    Get.updateLocale(Locale(selectedLanguage));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('current_language', selectedLanguage);
  }

  String getSelectedLanguage(){
    return selectedLanguage;
  }

  Map<String, Map<String, String>> getKeys(){
    return keys;
  }

  Future<Map<String, Map<String, String>>> loadKeys(String currentLanguageString) async{
    Map<String,String> languageKeys = await getKeysForLanguage(currentLanguageString);

    return {
      currentLanguageString: languageKeys
    };
  }

  Future<Map<String,String>> getKeysForLanguage(String labelsLanguage) async{
    // Load the new json
    String jsonString = await rootBundle.loadString(
        'assets/locales/$labelsLanguage.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    Map<String,String> localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return localizedStrings;
  }
}