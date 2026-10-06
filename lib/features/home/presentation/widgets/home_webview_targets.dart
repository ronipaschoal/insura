import 'home_nav_destinations.dart';
import 'home_quote_categories.dart';
import 'home_webview_target.dart';

/// Every [HomeWebViewTarget] on Home; ids are unique across all of them.
final List<HomeWebViewTarget> homeWebViewTargets = [
  ...homeQuoteCategories,
  ...homeMenuWebViewItems,
];

/// The target with [id], or null when there is none (e.g. a hand-edited URL).
HomeWebViewTarget? homeWebViewTargetById(String? id) {
  for (final target in homeWebViewTargets) {
    if (target.id == id) return target;
  }
  return null;
}
