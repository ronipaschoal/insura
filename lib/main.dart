import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/app.dart';
import 'core/di/injector.dart';

void main() {
  usePathUrlStrategy();
  setupInjector();
  runApp(const App());
}
