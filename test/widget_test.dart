// Smoke test: with no session restored, the app should land on the Login
// screen and let the user navigate to Register.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rugodymur/app.dart';
import 'package:rugodymur/data/local/prefs_service.dart';
import 'package:rugodymur/data/repositories/auth_repository.dart';
import 'package:rugodymur/models/app_user.dart';
import 'package:rugodymur/providers/auth_provider.dart';
import 'package:rugodymur/providers/cart_provider.dart';
import 'package:rugodymur/providers/theme_provider.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AppUser?> currentUser() async => null;

  @override
  Future<AppUser> login({required String email, required String password}) =>
      throw AuthException('not used in this test');

  @override
  Future<void> logout() async {}

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) => throw AuthException('not used in this test');

  @override
  Future<AppUser> updateProfile(AppUser user) async => user;
}

void main() {
  testWidgets('Shows Login screen and can navigate to Register', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await PrefsService.create();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
          ChangeNotifierProvider(create: (_) => AuthProvider(_FakeAuthRepository())),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: const RugodymurApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rugodymur'), findsWidgets);
    expect(find.text('LOG IN'), findsOneWidget);

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Create account'), findsOneWidget);
  });
}
