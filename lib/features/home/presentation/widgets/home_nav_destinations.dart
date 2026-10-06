import 'package:flutter/material.dart';

import 'home_webview_target.dart';

class HomeMenuItem implements HomeWebViewTarget {
  const HomeMenuItem({
    required this.id,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  @override
  final String id;
  @override
  final IconData icon;
  final IconData selectedIcon;
  @override
  final String label;
}

const HomeMenuItem homeMenuHome = HomeMenuItem(
  id: 'home',
  icon: Icons.home_outlined,
  selectedIcon: Icons.home,
  label: 'Home/Seguros',
);

/// Side menu items with no feature built yet: each opens the placeholder
/// WebView with its own icon and label in the app bar.
const List<HomeMenuItem> homeMenuWebViewItems = [
  HomeMenuItem(
    id: 'minhas-contratacoes',
    icon: Icons.assignment_turned_in_outlined,
    selectedIcon: Icons.assignment_turned_in,
    label: 'Minhas Contratações',
  ),
  HomeMenuItem(
    id: 'meus-sinistros',
    icon: Icons.report_problem_outlined,
    selectedIcon: Icons.report_problem,
    label: 'Meus Sinistros',
  ),
  HomeMenuItem(
    id: 'minha-familia',
    icon: Icons.family_restroom_outlined,
    selectedIcon: Icons.family_restroom,
    label: 'Minha Família',
  ),
  HomeMenuItem(
    id: 'meus-bens',
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
    label: 'Meus Bens',
  ),
  HomeMenuItem(
    id: 'pagamentos',
    icon: Icons.payments_outlined,
    selectedIcon: Icons.payments,
    label: 'Pagamentos',
  ),
  HomeMenuItem(
    id: 'coberturas',
    icon: Icons.verified_user_outlined,
    selectedIcon: Icons.verified_user,
    label: 'Coberturas',
  ),
  HomeMenuItem(
    id: 'validar-boleto',
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
    label: 'Validar Boleto',
  ),
  HomeMenuItem(
    id: 'telefones-importantes',
    icon: Icons.phone_outlined,
    selectedIcon: Icons.phone,
    label: 'Telefones Importantes',
  ),
  HomeMenuItem(
    id: 'configuracoes',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    label: 'Configurações',
  ),
];

/// Every side menu item in order: [homeMenuHome] first (index 0), then
/// [homeMenuWebViewItems] (index `i` is `homeMenuWebViewItems[i - 1]`).
const List<HomeMenuItem> homeMenuItems = [
  homeMenuHome,
  ...homeMenuWebViewItems,
];

/// Shared nav destinations, consumed by [ResponsiveScaffold] to build both
/// the mobile drawer and the desktop side menu from a single source.
final List<NavigationDestination> homeNavDestinations = [
  for (final item in homeMenuItems)
    NavigationDestination(
      icon: Icon(item.icon),
      selectedIcon: Icon(item.selectedIcon),
      label: item.label,
    ),
];
