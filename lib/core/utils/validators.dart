import 'package:flutter/widgets.dart';

import '../strings.dart';

class Validators {
  Validators._();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static const minPasswordLength = 6;

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return AppStrings.emailRequired;
    if (!_emailRegex.hasMatch(v)) return AppStrings.emailInvalid;
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return AppStrings.passwordRequired;
    if (v.length < minPasswordLength) return AppStrings.passwordTooShort;
    return null;
  }

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return AppStrings.nameRequired;
    if (v.length < 2) return AppStrings.nameTooShort;
    return null;
  }

  static FormFieldValidator<String> confirmPassword(
    String Function() original,
  ) {
    return (value) {
      if (value == null || value.isEmpty) return AppStrings.confirmRequired;
      if (value != original()) return AppStrings.passwordsDontMatch;
      return null;
    };
  }
}
