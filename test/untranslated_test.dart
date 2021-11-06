import 'dart:io';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

String sourceDir = 'lib';
String prefix = '\'';
String suffix = '\'\.tr';
RegExp exp = new RegExp(r"\'.+\'\.tr");
String localesDir = 'assets/locales';

void main() async{

  test('Find untranslated keys for portuguese', () async {
    List<String> translationKeys = await getTranslationKeys(false);
    String filePath = 'assets/locales/pt.json';

    List<String> missingKeys = await getMissingKeys(filePath, translationKeys);

    if(missingKeys.isNotEmpty) {
      reportMissingKeys(filePath, missingKeys);
      assert(false);
    }
  });

  test('Find untranslated keys in all files', () async {
    // Get all keys from dart source code
    List<String> translationKeys = await getTranslationKeys(true);

    // Check if all locales have all the keys
    Directory source = Directory(localesDir);
    List<FileSystemEntity> translationFiles = source.listSync(recursive: true).toList();

    for (FileSystemEntity translationFile in translationFiles) {
      if (translationFile.path.endsWith('.json')) {
        // Get missing keys
        List<String> missingKeys = await getMissingKeys(translationFile.path, translationKeys);

        if(missingKeys.isNotEmpty) {
          reportMissingKeys(translationFile.path, missingKeys);
        }
      }
    }

    assert(true);
  });
}

void reportMissingKeys(String filePath, List<String> missingKeys) {
  print('On file ' + filePath+ ' add: ');
  missingKeys.forEach((key) {

    if(filePath.contains('en.json')){
      print('"' + key + '": "' + key + '",');
    }
    else {
      print('"' + key + '": "",');
    }
  });

  print('------------');
}


Future<List<String>> getMissingKeys(String path, List<String> keys) async{
  List<String> missingKeys = [];
  String content = await File(path).readAsString();
  Map<String,dynamic> jsonObject = json.decode(content);
  List<String> jsonKeys = jsonObject.keys.toList();

  for(String key in keys) {
    if (!jsonKeys.contains(key)) {
      missingKeys.add(key);
    }
  }
  return missingKeys;
}

Future<List<String>> getTranslationKeys(searchForKeysInOtherFiles) async{
  List<String> keys = await getDartTranslationKeys();

  if(searchForKeysInOtherFiles) {
    // Check if all locales have all the keys
    Directory source = Directory(localesDir);
    List<FileSystemEntity> entries = source.listSync(recursive: true).toList();

    for (FileSystemEntity entry in entries) {
      if (entry.path.endsWith('.json')) {
        String content = await File(entry.path).readAsString();
        Map<String, dynamic> jsonObject = json.decode(content);
        List<String> jsonKeys = jsonObject.keys.toList();

        jsonKeys.forEach((key) {
          if (!keys.contains(key)) {
            keys.add(key);
          }
        });
      }
    }
  }

  return keys;
}

Future<List<String>> getDartTranslationKeys() async{
  List<String> result = [];

  print('Searching for stuff inside ' + sourceDir);
  Directory source = Directory(sourceDir);

  List<FileSystemEntity> entries = source.listSync(recursive: true).toList();

  print('Will validate ' + entries.length.toString() + ' files/folders');

  for (FileSystemEntity entry in entries) {
    if (entry.path.endsWith('.dart')) {
      String content = await File(entry.path).readAsString();

      Iterable<Match> matches = exp.allMatches(content);
      for (Match m in matches) {
        String match = m[0]!;
        match = match.replaceAll(suffix, '').replaceAll(prefix, '');
        if(!result.contains(match)) {
          result.add(match);
        }
      }
    }
  }

  return result;
}