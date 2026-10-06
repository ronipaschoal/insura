import 'package:flutter/widgets.dart';

/// Something on Home that opens `/webview` with its own icon and label in the
/// app bar — a quote category or a side menu item.
///
/// Only [id] travels in the URL (`/webview?page=<id>`); the route looks the
/// rest up with `homeWebViewTargetById`, since an [IconData] can't be passed
/// as a query parameter.
abstract interface class HomeWebViewTarget {
  String get id;
  IconData get icon;
  String get label;
}
