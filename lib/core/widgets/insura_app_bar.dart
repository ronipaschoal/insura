import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'insura_logo.dart';

/// Branded app bar shared by authenticated screens: [InsuraLogo] centered on
/// the dark home background, with a notifications action.
///
/// Pass [title] (and optionally [icon]) to show the current page instead of
/// the logo, e.g. the quote category a webview screen was opened for.
///
/// [leading] defaults to [AppBar]'s own (a back button when the route can
/// pop); [ResponsiveScaffold] passes its side menu toggle instead.
class InsuraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InsuraAppBar({
    super.key,
    this.leading,
    this.icon,
    this.title,
    this.onNotificationsTap,
  });

  final Widget? leading;
  final IconData? icon;
  final String? title;
  final VoidCallback? onNotificationsTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Themed itself so it looks the same on screens outside the dark home
    // shell (e.g. /webview, under the app's light theme).
    return Theme(
      data: AppTheme.home,
      child: AppBar(
        backgroundColor: AppColors.homeBackground,
        elevation: 0,
        centerTitle: true,
        leading: leading,
        title: title == null ? const InsuraLogo() : _PageTitle(icon, title!),
        actions: [
          IconButton(
            tooltip: 'Notificações',
            onPressed: onNotificationsTap,
            icon: const Badge(
              backgroundColor: AppColors.homeNotificationBadge,
              smallSize: 10,
              child: Icon(Icons.notifications_outlined),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle(this.icon, this.title);

  final IconData? icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColors.loginAccent, size: 22),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
