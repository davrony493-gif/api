import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'features/auth/data/mock_auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Swap MockAuthService for a real implementation (e.g. Strapi) here.
  runApp(App(authService: MockAuthService()));
}
