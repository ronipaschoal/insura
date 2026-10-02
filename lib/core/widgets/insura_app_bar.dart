import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'insura_logo.dart';

/// Branded app bar shared by authenticated screens: [InsuraLogo] centered on
/// the dark home background, with a notifications action.
///
/// [leading] defaults to [AppBar]'s own (a back button when the route can
/// pop); [ResponsiveScaffold] passes its side menu toggle instead.
class InsuraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InsuraAppBar({super.key, this.leading, this.onNotificationsTap});

  final Widget? leading;
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
        title: const InsuraLogo(),
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
