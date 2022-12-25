import 'package:shared_preferences/shared_preferences.dart';

mixin ThemeState {
  bool _isDark = true;

  Future<void> setIsDark(bool param) async {
    _isDark = param;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme', param);
  }

  bool isDark() => _isDark;

  Future<void> loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool? currentIsDark = prefs.getBool('theme');

    if (currentIsDark != null) {
      await setIsDark(currentIsDark);
    }
  }
}
