import '../../models/app_user.dart';

/// Auth is deliberately behind this interface so a FirebaseAuthRepository
/// (or an SSP-module-backed one) can be dropped in later without any
/// changes to AuthProvider or the Login/Register/Profile screens.
abstract class AuthRepository {
  Future<AppUser?> currentUser();

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });

  Future<AppUser> login({required String email, required String password});

  Future<void> logout();

  Future<AppUser> updateProfile(AppUser user);
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}
