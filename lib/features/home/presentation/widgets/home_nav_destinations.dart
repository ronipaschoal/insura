import 'package:flutter/material.dart';

/// Shared nav destinations, consumed by [ResponsiveScaffold] to build both
/// the mobile drawer and the desktop side menu from a single source.
const List<NavigationDestination> homeNavDestinations = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
    label: 'Início',
  ),
  NavigationDestination(
    icon: Icon(Icons.public_outlined),
    selectedIcon: Icon(Icons.public),
    label: 'WebView',
  ),
];
