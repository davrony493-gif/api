import 'package:flutter/widgets.dart';

import '../data/auth_service.dart';

/// Makes the [AuthService] available to every screen below it.
class AuthScope extends InheritedWidget {
  const AuthScope({super.key, required this.service, required super.child});

  final AuthService service;

  static AuthService of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'No AuthScope found in context');
    return scope!.service;
  }

  @override
  bool updateShouldNotify(AuthScope oldWidget) => service != oldWidget.service;
}
