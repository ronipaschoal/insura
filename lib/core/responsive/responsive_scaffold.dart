import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/insura_logo.dart';
import 'breakpoints.dart';

/// Navigation shell shared by authenticated screens: a side menu
/// ([NavigationRail], collapsible via the leading menu button) on
/// desktop/web widths, a [Drawer] ([NavigationDrawer]) on mobile widths.
class ResponsiveScaffold extends StatefulWidget {
  const ResponsiveScaffold({
    super.key,
    required this.body,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.onLogout,
    this.onNotificationsTap,
  });

  final Widget body;
  final List<NavigationDestination> destinations;
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

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= Breakpoints.desktop;

    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.homeBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.loginAccent,
          brightness: Brightness.dark,
          surface: AppColors.homeSurface,
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.homeBackground,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: isDesktop ? 'Recolher/expandir menu' : 'Abrir menu',
            onPressed: () {
              if (isDesktop) {
                setState(() => _railExpanded = !_railExpanded);
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
          title: const InsuraLogo(),
          actions: [
            IconButton(
              tooltip: 'Notificações',
              onPressed: widget.onNotificationsTap,
              icon: const Badge(
                backgroundColor: AppColors.homeNotificationBadge,
                smallSize: 10,
                child: Icon(Icons.notifications_outlined),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
        drawer: isDesktop
            ? null
            : NavigationDrawer(
                backgroundColor: AppColors.homeSurface,
                selectedIndex: widget.selectedIndex,
                onDestinationSelected: (index) {
                  Navigator.of(context).pop();
                  widget.onDestinationSelected?.call(index);
                },
                children: [
                  for (final destination in widget.destinations)
                    NavigationDrawerDestination(
                      icon: destination.icon,
                      selectedIcon: destination.selectedIcon,
                      label: Text(destination.label),
                    ),
                  if (widget.onLogout != null) ...[
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Sair'),
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onLogout!();
                      },
                    ),
                  ],
                ],
              ),
        body: isDesktop
            ? Row(
                children: [
                  NavigationRail(
                    extended: _railExpanded,
                    minExtendedWidth: 220,
                    backgroundColor: AppColors.homeSurface,
                    selectedIndex: widget.selectedIndex,
                    onDestinationSelected: widget.onDestinationSelected,
                    destinations: [
                      for (final destination in widget.destinations)
                        NavigationRailDestination(
                          icon: destination.icon,
                          selectedIcon: destination.selectedIcon,
                          label: Text(destination.label),
                        ),
                    ],
                    trailing: widget.onLogout == null
                        ? null
                        : Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _railExpanded
                                    ? InkWell(
                                        onTap: widget.onLogout,
                                        borderRadius: BorderRadius.circular(8),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.logout),
                                              SizedBox(width: 12),
                                              Text('Sair'),
                                            ],
                                          ),
                                        ),
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.logout),
                                        tooltip: 'Sair',
                                        onPressed: widget.onLogout,
                                      ),
                              ),
                            ),
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
