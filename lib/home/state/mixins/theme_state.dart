import 'package:shared_preferences/shared_preferences.dart';

mixin ThemeState {
  bool _isDark = true;

  Future<void> setIsDark(bool param) async {
    _isDark = param;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme', param);
  }

  bool isDark() {
    return _isDark;
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? currentIsDark = prefs.getBool('theme');

    if (currentIsDark != null) {
      setIsDark(currentIsDark);
    }
  }
}
