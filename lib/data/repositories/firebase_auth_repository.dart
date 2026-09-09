import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../models/app_user.dart';
import '../local/local_db.dart';
import 'auth_repository.dart';

/// Firebase-backed [AuthRepository]. Local-only profile fields that Firebase
/// Auth has no concept of (the on-device avatar file path) are cached in the
/// same Hive users box the local implementation used, keyed by uid.
class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _auth;

  FirebaseAuthRepository([fb.FirebaseAuth? auth]) : _auth = auth ?? fb.FirebaseAuth.instance;

  AppUser _toAppUser(fb.User user) {
    final cached = LocalDb.usersBox.get(user.uid);
    final avatarPath = cached is Map ? cached['avatarPath'] as String? : null;
    return AppUser(
      id: user.uid,
      name: user.displayName ?? user.email?.split('@').first ?? 'User',
      email: user.email ?? '',
      passwordHash: '',
      avatarPath: avatarPath,
    );
  }

  AuthException _mapError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return AuthException('An account with this email already exists.');
      case 'user-not-found':
      case 'invalid-credential':
        return AuthException('No account found for this email.');
      case 'wrong-password':
        return AuthException('Incorrect password.');
      case 'weak-password':
        return AuthException('Password is too weak.');
      case 'invalid-email':
        return AuthException('That email address looks invalid.');
      default:
        return AuthException(e.message ?? 'Authentication failed.');
    }
  }

  @override
  Future<AppUser?> currentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _toAppUser(user);
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user!.updateDisplayName(name.trim());
      await credential.user!.reload();
      return _toAppUser(_auth.currentUser!);
    } on fb.FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<AppUser> login({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _toAppUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<AppUser> updateProfile(AppUser user) async {
    final current = _auth.currentUser;
    if (current == null) throw AuthException('Not signed in.');
    await current.updateDisplayName(user.name);
    await LocalDb.usersBox.put(current.uid, {'avatarPath': user.avatarPath});
    await current.reload();
    return _toAppUser(_auth.currentUser!);
  }
}
