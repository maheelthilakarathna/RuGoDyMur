import 'dart:async';
import 'package:flutter/material.dart';

import '../data/local/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _service;
  bool _isOnline = true;
  StreamSubscription<bool>? _sub;

  ConnectivityProvider({ConnectivityService? service})
    : _service = service ?? ConnectivityService() {
    _init();
  }

  bool get isOnline => _isOnline;

  Future<void> _init() async {
    _isOnline = await _service.isOnline();
    notifyListeners();
    _sub = _service.onStatusChange.listen((online) {
      if (online != _isOnline) {
        _isOnline = online;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
