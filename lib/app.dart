import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/main_shell.dart';
import 'utils/theme.dart';

class RugodymurApp extends StatelessWidget {
  const RugodymurApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'Rugodymur',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.mode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const _AuthGate(),
    );
  }
}

/// Shows Login until a session is restored/created, then keeps the cart
/// provider attached to whichever user is currently logged in.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    switch (auth.status) {
      case AuthStatus.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.loggedOut:
        return const LoginScreen();
      case AuthStatus.loggedIn:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<CartProvider>().attachUser(auth.user?.id);
        });
        return const MainShell();
    }
  }
}
