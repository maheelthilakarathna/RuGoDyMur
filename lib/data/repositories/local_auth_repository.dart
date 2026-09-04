import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../../models/app_user.dart';
import '../local/local_db.dart';
import '../local/prefs_service.dart';
import 'auth_repository.dart';

/// Mock local auth backed by a Hive box, keyed by lower-cased email. This is
/// the swap target described on AuthRepository: replace with
/// FirebaseAuthRepository later without touching the UI layer.
class LocalAuthRepository implements AuthRepository {
  final PrefsService _prefs;

  LocalAuthRepository(this._prefs);

  String _hash(String password) => sha256.convert(utf8.encode(password)).toString();

  @override
  Future<AppUser?> currentUser() async {
    final id = _prefs.sessionUserId;
    if (id == null) return null;
    final raw = LocalDb.usersBox.get(id);
    if (raw == null) return null;
    return AppUser.fromJson(Map<String, dynamic>.from(raw as Map));
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final key = email.trim().toLowerCase();
    if (LocalDb.usersBox.containsKey(key)) {
      throw AuthException('An account with this email already exists.');
    }
    final user = AppUser(
      id: key,
      name: name.trim(),
      email: key,
      passwordHash: _hash(password),
    );
    await LocalDb.usersBox.put(key, user.toJson());
    await _prefs.setSessionUserId(key);
    return user;
  }

  @override
  Future<AppUser> login({required String email, required String password}) async {
    final key = email.trim().toLowerCase();
    final raw = LocalDb.usersBox.get(key);
    if (raw == null) {
      throw AuthException('No account found for this email.');
    }
    final user = AppUser.fromJson(Map<String, dynamic>.from(raw as Map));
    if (user.passwordHash != _hash(password)) {
      throw AuthException('Incorrect password.');
    }
    await _prefs.setSessionUserId(key);
    return user;
  }

  @override
  Future<void> logout() async {
    await _prefs.setSessionUserId(null);
  }

  @override
  Future<AppUser> updateProfile(AppUser user) async {
    await LocalDb.usersBox.put(user.id, user.toJson());
    return user;
  }
}
