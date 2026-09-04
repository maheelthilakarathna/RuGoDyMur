import 'package:flutter/material.dart';

import '../data/repositories/auth_repository.dart';
import '../models/app_user.dart';

enum AuthStatus { loading, loggedOut, loggedIn }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.loading;
  AppUser? _user;
  String? _error;

  AuthProvider(this._repository) {
    _restoreSession();
  }

  AuthStatus get status => _status;
  AppUser? get user => _user;
  String? get error => _error;

  Future<void> _restoreSession() async {
    final user = await _repository.currentUser();
    _user = user;
    _status = user != null ? AuthStatus.loggedIn : AuthStatus.loggedOut;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _error = null;
    try {
      _user = await _repository.login(email: email, password: password);
      _status = AuthStatus.loggedIn;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _error = null;
    try {
      _user = await _repository.register(name: name, email: email, password: password);
      _status = AuthStatus.loggedIn;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    _status = AuthStatus.loggedOut;
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? avatarPath}) async {
    if (_user == null) return;
    final updated = _user!.copyWith(name: name, avatarPath: avatarPath);
    _user = await _repository.updateProfile(updated);
    notifyListeners();
  }
}
