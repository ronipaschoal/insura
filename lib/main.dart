import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/di/injector.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hash-based URLs (/#/home) on purpose: the hosting server has no rewrite
  // rule to fall back to index.html for deep links, so usePathUrlStrategy()
  // would 404 on a direct/refreshed visit to e.g. /login.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupInjector();
  runApp(const App());
}
