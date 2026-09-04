import 'package:shared_preferences/shared_preferences.dart';

/// Wraps SharedPreferences for simple key/value app settings: theme mode
/// override and the currently logged-in user's id (session persistence).
class PrefsService {
  static const _themeModeKey = 'theme_mode';
  static const _sessionUserIdKey = 'session_user_id';

  final SharedPreferences _prefs;

  PrefsService(this._prefs);

  static Future<PrefsService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefsService(prefs);
  }

  String? get themeMode => _prefs.getString(_themeModeKey);

  Future<void> setThemeMode(String mode) => _prefs.setString(_themeModeKey, mode);

  String? get sessionUserId => _prefs.getString(_sessionUserIdKey);

  Future<void> setSessionUserId(String? id) async {
    if (id == null) {
      await _prefs.remove(_sessionUserIdKey);
    } else {
      await _prefs.setString(_sessionUserIdKey, id);
    }
  }
}
