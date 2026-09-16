import 'package:flutter/material.dart';

/// Shared nav destinations, consumed by [ResponsiveScaffold] to build both
/// the mobile drawer and the desktop side menu from a single source.
const List<NavigationDestination> homeNavDestinations = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
    label: 'Home/Seguros',
  ),
  NavigationDestination(
    icon: Icon(Icons.assignment_turned_in_outlined),
    selectedIcon: Icon(Icons.assignment_turned_in),
    label: 'Minhas Contratações',
  ),
  NavigationDestination(
    icon: Icon(Icons.report_problem_outlined),
    selectedIcon: Icon(Icons.report_problem),
    label: 'Meus Sinistros',
  ),
  NavigationDestination(
    icon: Icon(Icons.family_restroom_outlined),
    selectedIcon: Icon(Icons.family_restroom),
    label: 'Minha Família',
  ),
  NavigationDestination(
    icon: Icon(Icons.inventory_2_outlined),
    selectedIcon: Icon(Icons.inventory_2),
    label: 'Meus Bens',
  ),
  NavigationDestination(
    icon: Icon(Icons.payments_outlined),
    selectedIcon: Icon(Icons.payments),
    label: 'Pagamentos',
  ),
  NavigationDestination(
    icon: Icon(Icons.verified_user_outlined),
    selectedIcon: Icon(Icons.verified_user),
    label: 'Coberturas',
  ),
  NavigationDestination(
    icon: Icon(Icons.receipt_long_outlined),
    selectedIcon: Icon(Icons.receipt_long),
    label: 'Validar Boleto',
  ),
  NavigationDestination(
    icon: Icon(Icons.phone_outlined),
    selectedIcon: Icon(Icons.phone),
    label: 'Telefones Importantes',
  ),
  NavigationDestination(
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings),
    label: 'Configurações',
  ),
];
