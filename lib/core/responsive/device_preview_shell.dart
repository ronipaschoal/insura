import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'breakpoints.dart';

enum DevicePreviewMode { web, mobile }

/// Wraps the whole app (via [MaterialApp.builder]) so that, on large screens,
/// a bottom banner lets the user switch between the regular web layout and
/// the app rendered inside a mocked phone in the middle of the screen.
///
/// The phone gets its own [MediaQuery] (a phone-sized screen with status bar
/// and home indicator insets), so [ResponsiveScaffold] and every other
/// layout inside it behave exactly as on a real phone. Below
/// [Breakpoints.desktop] it renders [child] untouched.
class DevicePreviewShell extends StatefulWidget {
  const DevicePreviewShell({
    super.key,
    required this.child,
    this.initialMode = DevicePreviewMode.web,
  });

  final Widget child;
  final DevicePreviewMode initialMode;

  /// Logical screen size of the mocked phone (an iPhone 14/15-like screen).
  static const Size phoneScreenSize = Size(390, 844);

  @override
  State<DevicePreviewShell> createState() => _DevicePreviewShellState();
}

class _DevicePreviewShellState extends State<DevicePreviewShell> {
  // Keeps the app (navigator, page state, webviews) alive while it is moved
  // in and out of the phone frame.
  final _appKey = GlobalKey();
  late DevicePreviewMode _mode = widget.initialMode;

  @override
  Widget build(BuildContext context) {
    final app = KeyedSubtree(key: _appKey, child: widget.child);
    final isLarge = MediaQuery.sizeOf(context).width >= Breakpoints.desktop;
    if (!isLarge) return app;

    return Column(
      children: [
        Expanded(
          child: switch (_mode) {
            DevicePreviewMode.web => app,
            DevicePreviewMode.mobile => _PhoneMockup(child: app),
          },
        ),
        _DevicePreviewBanner(
          mode: _mode,
          onModeChanged: (mode) => setState(() => _mode = mode),
        ),
      ],
    );
  }
}

class _PhoneMockup extends StatelessWidget {
  const _PhoneMockup({required this.child});

  final Widget child;

  static const double _bezel = 12;
  static const double _screenRadius = 44;
  static const EdgeInsets _phoneInsets = EdgeInsets.only(top: 47, bottom: 34);

  @override
  Widget build(BuildContext context) {
    const screen = DevicePreviewShell.phoneScreenSize;
    final mediaQuery = MediaQuery.of(context);

    return ColoredBox(
      color: AppColors.loginBackgroundDark,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          // Scales the whole phone down when the window is too short for it,
          // keeping the app inside at its real phone resolution.
          child: FittedBox(
            child: Container(
              padding: const EdgeInsets.all(_bezel),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(_screenRadius + _bezel),
                border: Border.all(color: const Color(0xFF3A3B48), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 40,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_screenRadius),
                child: SizedBox.fromSize(
                  size: screen,
                  child: Stack(
                    children: [
                      MediaQuery(
                        data: mediaQuery.copyWith(
                          size: screen,
                          padding: _phoneInsets,
                          viewPadding: _phoneInsets,
                          viewInsets: EdgeInsets.zero,
                        ),
                        child: child,
                      ),
                      const _DynamicIsland(),
                      const _HomeIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: IgnorePointer(
        child: Container(
          margin: const EdgeInsets.only(top: 11),
          width: 120,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: 134,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

class _DevicePreviewBanner extends StatelessWidget {
  const _DevicePreviewBanner({required this.mode, required this.onModeChanged});

  final DevicePreviewMode mode;
  final ValueChanged<DevicePreviewMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    // Outside the app's Navigator (so no Overlay: no tooltips here), and
    // themed itself since MaterialApp.builder sits above every page theme.
    return Theme(
      data: AppTheme.home,
      child: Material(
        color: AppColors.homeSurface,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.devices_outlined, color: Colors.white70),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Visualizar como',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                SegmentedButton<DevicePreviewMode>(
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    selectedForegroundColor: AppColors.loginBackgroundDark,
                    selectedBackgroundColor: AppColors.loginAccent,
                    side: const BorderSide(color: AppColors.loginFieldBorder),
                  ),
                  segments: const [
                    ButtonSegment(
                      value: DevicePreviewMode.web,
                      icon: Icon(Icons.desktop_windows_outlined),
                      label: Text('Web'),
                    ),
                    ButtonSegment(
                      value: DevicePreviewMode.mobile,
                      icon: Icon(Icons.smartphone_outlined),
                      label: Text('Mobile'),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (selection) =>
                      onModeChanged(selection.single),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
