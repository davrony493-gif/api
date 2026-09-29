import 'package:flutter/material.dart';

import 'core/strings.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_service.dart';
import 'features/auth/presentation/auth_scope.dart';
import 'features/auth/presentation/forgot_password_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/presentation/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      service: authService,
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        routes: {
          RegisterScreen.route: (_) => const RegisterScreen(),
          ForgotPasswordScreen.route: (_) => const ForgotPasswordScreen(),
        },
      ),
    );
  }
}
