import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

/// Detects a device "shake" from the accelerometer stream so the UI can
/// react to it (used on the Pet Facts screen to fetch a new fact/photo).
class SensorService {
  static const double _shakeThreshold = 18.0;
  static const Duration _cooldown = Duration(milliseconds: 800);

  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);

  Stream<void> get onShake {
    late StreamController<void> controller;
    controller = StreamController<void>.broadcast(
      onListen: () {
        _subscription = accelerometerEventStream().listen((event) {
          final magnitude = sqrt(
            event.x * event.x + event.y * event.y + event.z * event.z,
          );
          final now = DateTime.now();
          if (magnitude > _shakeThreshold &&
              now.difference(_lastShake) > _cooldown) {
            _lastShake = now;
            controller.add(null);
          }
        });
      },
      onCancel: () => _subscription?.cancel(),
    );
    return controller.stream;
  }

  void dispose() {
    _subscription?.cancel();
  }
}
