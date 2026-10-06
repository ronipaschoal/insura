import 'package:flutter_test/flutter_test.dart';
import 'package:insura/features/home/presentation/widgets/home_nav_destinations.dart';
import 'package:insura/features/home/presentation/widgets/home_webview_targets.dart';

void main() {
  test('ids are unique across quote categories and menu items', () {
    final ids = homeWebViewTargets.map((target) => target.id);

    expect(ids.toSet(), hasLength(homeWebViewTargets.length));
  });

  test('finds a quote category by its id', () {
    expect(homeWebViewTargetById('vida')?.label, 'Vida');
  });

  test('finds a side menu item by its id', () {
    expect(homeWebViewTargetById('pagamentos')?.label, 'Pagamentos');
  });

  test('returns null for an unknown or missing id, and for Home', () {
    expect(homeWebViewTargetById('nope'), isNull);
    expect(homeWebViewTargetById(null), isNull);
    expect(homeWebViewTargetById(homeMenuHome.id), isNull);
  });

  test('nav destinations mirror the menu items, Home first', () {
    expect(
      homeNavDestinations.map((destination) => destination.label),
      homeMenuItems.map((item) => item.label),
    );
    expect(homeNavDestinations.first.label, homeMenuHome.label);
  });
}
