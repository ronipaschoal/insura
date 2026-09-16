import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Custom authenticated-shell side menu: a user header (avatar + name) plus
/// the nav item list and a logout entry. Rendered inside the fixed sidebar
/// on desktop/web and inside the [Drawer] on mobile by [ResponsiveScaffold].
/// [expanded] toggles between the full (icon + label) and collapsed
/// (icon-only) layouts used for the collapsible desktop sidebar.
class AppSideMenu extends StatelessWidget {
  const AppSideMenu({
    super.key,
    required this.userName,
    required this.destinations,
    required this.selectedIndex,
    required this.expanded,
    this.onDestinationSelected,
    this.onLogout,
  });

  final String userName;
  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final bool expanded;
  final ValueChanged<int>? onDestinationSelected;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: expanded
              ? _ExpandedHeader(userName: userName)
              : const _CollapsedHeader(),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              for (var i = 0; i < destinations.length; i++)
                _SideMenuItem(
                  icon: i == selectedIndex
                      ? destinations[i].selectedIcon ?? destinations[i].icon
                      : destinations[i].icon,
                  label: destinations[i].label,
                  expanded: expanded,
                  selected: i == selectedIndex,
                  onTap: onDestinationSelected == null
                      ? null
                      : () => onDestinationSelected!(i),
                ),
            ],
          ),
        ),
        if (onLogout != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: expanded ? 20 : 0,
              vertical: 12,
            ),
            child: expanded
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: onLogout,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white54,
                      ),
                      child: const Text('Sair'),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Sair',
                    color: Colors.white54,
                    onPressed: onLogout,
                  ),
          ),
      ],
    );
  }
}

class _ExpandedHeader extends StatelessWidget {
  const _ExpandedHeader({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Olá!',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                (userName.isEmpty ? 'Usuário' : userName).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.only(left: 46),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Minha conta',
                style: TextStyle(color: AppColors.loginAccent, fontSize: 12),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.loginAccent,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CollapsedHeader extends StatelessWidget {
  const _CollapsedHeader();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white24,
        child: Icon(Icons.person, color: Colors.white, size: 20),
      ),
    );
  }
}

class _SideMenuItem extends StatelessWidget {
  const _SideMenuItem({
    required this.icon,
    required this.label,
    required this.expanded,
    required this.selected,
    this.onTap,
  });

  final Widget icon;
  final String label;
  final bool expanded;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.loginAccent : Colors.white70;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: expanded ? 20 : 0,
          vertical: 12,
        ),
        child: Row(
          mainAxisAlignment: expanded
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(color: color, size: 20),
              child: icon,
            ),
            if (expanded) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: color, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
