import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String sourceDir = 'lib';
String prefix = "'";
String suffix = "'.tr";
RegExp exp = RegExp(r"\'.+\'\.t");
String localesDir = 'assets/locales';

void main() async {
  test('Find untranslated keys for portuguese', () async {
    final List<String> translationKeys = await getTranslationKeys(false);
    const String filePath = 'assets/locales/pt.json';

    final List<String> missingKeys =
        await getMissingKeys(filePath, translationKeys);

    if (missingKeys.isNotEmpty) {
      reportMissingKeys(filePath, missingKeys);
      assert(false);
    }
  });

  test('Find untranslated keys in all files', () async {
    // Get all keys from dart source code
    final List<String> translationKeys = await getTranslationKeys(true);

    // Check if all locales have all the keys
    final Directory source = Directory(localesDir);
    final List<FileSystemEntity> translationFiles =
        source.listSync(recursive: true).toList();

    for (final FileSystemEntity translationFile in translationFiles) {
      if (translationFile.path.endsWith('.json')) {
        // Get missing keys
        final List<String> missingKeys =
            await getMissingKeys(translationFile.path, translationKeys);

        if (missingKeys.isNotEmpty) {
          reportMissingKeys(translationFile.path, missingKeys);
        }
      }
    }

    assert(true);
  });
}

void reportMissingKeys(String filePath, List<String> missingKeys) {
  print('On file $filePath add: ');
  missingKeys.forEach((key) {
    if (filePath.contains('en.json')) {
      print('"$key": "$key",');
    } else {
      print('"$key": "",');
    }
  });

  print('------------');
}

Future<List<String>> getMissingKeys(String path, List<String> keys) async {
  final List<String> missingKeys = [];
  final String content = await File(path).readAsString();
  final Map<String, dynamic> jsonObject =
      json.decode(content) as Map<String, dynamic>;
  final List<String> jsonKeys = jsonObject.keys.toList();

  for (final String key in keys) {
    if (!jsonKeys.contains(key)) {
      missingKeys.add(key);
    }
  }
  return missingKeys;
}

Future<List<String>> getTranslationKeys(bool searchForKeysInOtherFiles) async {
  final List<String> keys = await getDartTranslationKeys();

  if (searchForKeysInOtherFiles) {
    // Check if all locales have all the keys
    final Directory source = Directory(localesDir);
    final List<FileSystemEntity> entries =
        source.listSync(recursive: true).toList();

    for (final FileSystemEntity entry in entries) {
      if (entry.path.endsWith('.json')) {
        final String content = await File(entry.path).readAsString();
        final Map<String, dynamic> jsonObject =
            json.decode(content) as Map<String, dynamic>;
        final List<String> jsonKeys = jsonObject.keys.toList();

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

Future<List<String>> getDartTranslationKeys() async {
  final List<String> result = [];

  print('Searching for stuff inside $sourceDir');
  final Directory source = Directory(sourceDir);

  final List<FileSystemEntity> entries =
      source.listSync(recursive: true).toList();

  print('Will validate ${entries.length} files/folders');

  for (final FileSystemEntity entry in entries) {
    if (entry.path.endsWith('.dart')) {
      final String content = await File(entry.path).readAsString();

      final Iterable<Match> matches = exp.allMatches(content);
      for (final Match m in matches) {
        String match = m[0]!;
        match = match.replaceAll(suffix, '').replaceAll(prefix, '');
        if (!result.contains(match)) {
          result.add(match);
        }
      }
    }
  }

  return result;
}
