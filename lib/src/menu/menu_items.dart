import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;

  MenuItem({
    required this.title,
    required this.icon,
  });
}

final appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Home',
    icon: Icons.home,
  ),
  MenuItem(
    title: 'Apartments',
    icon: Icons.apartment,
  ),
  MenuItem(
    title: 'Loessa',
    icon: Icons.business,
  ),
  MenuItem(
    title: 'Colmados',
    icon: Icons.store,
  ),
];
