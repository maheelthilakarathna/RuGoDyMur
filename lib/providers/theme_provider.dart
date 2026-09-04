import 'package:flutter/material.dart';

import '../data/local/prefs_service.dart';

/// Defaults to following the device's system light/dark setting, but lets
/// the user override it from Profile; the override is persisted.
class ThemeProvider extends ChangeNotifier {
  final PrefsService _prefs;
  ThemeMode _mode;

  ThemeProvider(this._prefs) : _mode = _fromString(_prefs.themeMode);

  ThemeMode get mode => _mode;

  static ThemeMode _fromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setThemeMode(value);
  }
}
