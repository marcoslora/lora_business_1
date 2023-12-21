import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lora_business_1/src/menu/menu_items.dart';

class SideMenu extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    return NavigationDrawer(
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          widget.onDestinationSelected(index);
        });
      },
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(28, hasNotch ? 20 : 20, 16, 10),
            child: const Text('Homes')),
        ...appMenuItems.map((item) => NavigationDrawerDestination(
              icon: Icon(item.icon),
              label: Text(item.title),
            )),
      ],
    );
  }
}
