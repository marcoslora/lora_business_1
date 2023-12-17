import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

int navIndex = 0;

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top;
    if (Platform.isIOS) {
      print('IOS $hasNotch');
    } else {
      print('Android $hasNotch');
    }
    return NavigationDrawer(
      selectedIndex: navIndex,
      onDestinationSelected: (index) {
        setState(() {
          navIndex = index;
        });
      },
      children: const [
        Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 20), child: Text('Home')),
        NavigationDrawerDestination(
          icon: Icon(Icons.home),
          label: Text('Home'),
          // destination: const HomePage(),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.apartment),
          label: Text('Apartments'),
          // destination: const ApartmentsPage(),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.business),
          label: Text('Loessa'),
          // destination: const LoessaPage(),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.store),
          label: Text('Colmados'),
          // destination: const ColmadosPage(),
        ),
      ],
    );
  }
}
