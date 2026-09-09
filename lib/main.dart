import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/local/local_db.dart';
import 'data/local/prefs_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/firebase_auth_repository.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/nav_index_provider.dart';
import 'providers/product_provider.dart';
import 'providers/theme_provider.dart';
import 'services/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalDb.init();
  final prefs = await PrefsService.create();
  unawaited(PushNotificationService().init());

  runApp(
    MultiProvider(
      providers: [
        Provider<PrefsService>.value(value: prefs),
        Provider<AuthRepository>(create: (_) => FirebaseAuthRepository()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => NavIndexProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const RugodymurApp(),
    ),
  );
}
