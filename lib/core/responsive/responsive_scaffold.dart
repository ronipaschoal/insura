import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/insura_app_bar.dart';
import 'app_side_menu.dart';
import 'breakpoints.dart';

/// Navigation shell shared by authenticated screens: a fixed side menu
/// ([AppSideMenu], collapsible via the leading menu button) on desktop/web
/// widths, a [Drawer] wrapping the same menu on mobile widths.
class ResponsiveScaffold extends StatefulWidget {
  const ResponsiveScaffold({
    super.key,
    required this.body,
    required this.destinations,
    required this.userName,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.onLogout,
    this.onNotificationsTap,
  });

  final Widget body;
  final List<NavigationDestination> destinations;
  final String userName;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final VoidCallback? onLogout;
  final VoidCallback? onNotificationsTap;

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _railExpanded = true;
  // Mirrors _railExpanded, but only flips to true once the sidebar has
  // finished growing back to _expandedWidth (see AnimatedContainer.onEnd
  // below) — showing full-width labels/header while the container is still
  // narrower than that overflows AppSideMenu's expanded layout. Collapsing
  // is safe to apply immediately since shrinking content never overflows.
  bool _menuContentExpanded = true;

  static const _expandedWidth = 260.0;
  static const _collapsedWidth = 72.0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= Breakpoints.desktop;

    return Theme(
      data: AppTheme.home,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: InsuraAppBar(
          onNotificationsTap: widget.onNotificationsTap,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: isDesktop ? 'Recolher/expandir menu' : 'Abrir menu',
            onPressed: () {
              if (isDesktop) {
                setState(() {
                  _railExpanded = !_railExpanded;
                  if (!_railExpanded) _menuContentExpanded = false;
                });
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
        ),
        drawer: isDesktop
            ? null
            : Drawer(
                backgroundColor: AppColors.homeSurface,
                child: SafeArea(
                  child: AppSideMenu(
                    userName: widget.userName,
                    destinations: widget.destinations,
                    selectedIndex: widget.selectedIndex,
                    expanded: true,
                    onDestinationSelected: (index) {
                      Navigator.of(context).pop();
                      widget.onDestinationSelected?.call(index);
                    },
                    onLogout: widget.onLogout == null
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            widget.onLogout!();
                          },
                  ),
                ),
              ),
        body: isDesktop
            ? Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: _railExpanded ? _expandedWidth : _collapsedWidth,
                    color: AppColors.homeSurface,
                    onEnd: () {
                      if (_railExpanded) {
                        setState(() => _menuContentExpanded = true);
                      }
                    },
                    child: AppSideMenu(
                      userName: widget.userName,
                      destinations: widget.destinations,
                      selectedIndex: widget.selectedIndex,
                      expanded: _menuContentExpanded,
                      onDestinationSelected: widget.onDestinationSelected,
                      onLogout: widget.onLogout,
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: widget.body),
                ],
              )
            : widget.body,
      ),
    );
  }
}
