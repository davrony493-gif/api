import 'dart:async';

import 'package:banking_app/app.dart';
import 'package:banking_app/core/widgets/liquid_glass_navigation_bar.dart';
import 'package:banking_app/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory AuthService with no delays or storage.
class FakeAuthService implements AuthService {
  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _user;

  @override
  AppUser? get currentUser => _user;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _user;
    yield* _controller.stream;
  }

  @override
  Future<AppUser> signIn({required String email, required String password}) =>
      _set(AppUser(id: email, email: email, name: 'Test User'));

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) => _set(AppUser(id: email, email: email, name: name));

  @override
  Future<void> resetPassword({required String email}) async {}

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }

  Future<AppUser> _set(AppUser user) async {
    _user = user;
    _controller.add(user);
    return user;
  }
}

void main() {
  testWidgets('splash -> login -> sign in -> home -> sign out', (tester) async {
    await tester.pumpWidget(App(authService: FakeAuthService()));
    expect(find.text('Banking App'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);

    // Validation blocks empty submit.
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pump();
    expect(find.text('Please enter your email'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Test'), findsOneWidget);
    expect(find.byType(LiquidGlassNavigationBar), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
