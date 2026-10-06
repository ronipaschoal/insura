// Renders the launcher icon source images in assets/icon/ from the brand
// mark (the InsuraLogo shield over the login gradient).
//
// Regenerate with:
//   flutter test tool/app_icon/generate_app_icon_test.dart
//   dart run flutter_launcher_icons
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insura/core/theme/app_colors.dart';

const double _size = 1024;
const String _outDir = 'assets/icon';

const _gradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [AppColors.loginGradientStart, AppColors.loginGradientEnd],
);

void main() {
  testWidgets('generate launcher icon images', (tester) async {
    await tester.runAsync(_loadMaterialIcons);

    // Full icon (iOS, web, legacy Android): gradient + shield.
    await _render(
      tester,
      const _IconImage(background: true, shieldFactor: 0.6),
      'app_icon.png',
    );
    // Android adaptive icon layers: the foreground must fit the 66% safe
    // zone, since launchers crop the outer area to their own mask shape.
    await _render(
      tester,
      const _IconImage(background: false, shieldFactor: 0.42),
      'app_icon_foreground.png',
    );
    await _render(
      tester,
      const _IconImage(background: true, shieldFactor: 0),
      'app_icon_background.png',
    );
  });
}

Future<void> _loadMaterialIcons() async {
  final flutterRoot =
      Platform.environment['FLUTTER_ROOT'] ??
      File(
        Platform.resolvedExecutable,
      ).parent.parent.parent.parent.parent.parent.path;
  final font = File(
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  final loader = FontLoader('MaterialIcons')
    ..addFont(font.readAsBytes().then(ByteData.sublistView));
  await loader.load();
}

Future<void> _render(WidgetTester tester, Widget icon, String fileName) async {
  final key = GlobalKey();
  tester.view
    ..physicalSize = const Size(_size, _size)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(RepaintBoundary(key: key, child: icon));

  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$_outDir/$fileName');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
  });
}

class _IconImage extends StatelessWidget {
  const _IconImage({required this.background, required this.shieldFactor});

  final bool background;

  /// Shield glyph size as a fraction of the icon size (0 hides it).
  final double shieldFactor;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: background ? _gradient : null),
        child: Center(
          child: shieldFactor == 0
              ? null
              : Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: _size * shieldFactor,
                ),
        ),
      ),
    );
  }
}
