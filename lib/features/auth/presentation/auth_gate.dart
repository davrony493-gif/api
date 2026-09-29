import 'package:flutter/material.dart';

import '../../home/presentation/home_shell.dart';
import '../data/auth_service.dart';
import 'auth_scope.dart';
import 'login_screen.dart';

/// Shows [LoginScreen] or [HomeShell] depending on the auth state.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late AuthService _auth;
  Stream<AppUser?>? _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_stream == null) {
      _auth = AuthScope.of(context);
      _stream = _auth.authStateChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: _stream,
      initialData: _auth.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: user == null
              ? const LoginScreen(key: ValueKey('login'))
              : HomeShell(key: const ValueKey('home'), user: user),
        );
      },
    );
  }
}
