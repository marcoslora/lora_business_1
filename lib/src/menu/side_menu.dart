import 'package:firebase_auth/firebase_auth.dart';
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
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(28, hasNotch ? 50 : 40, 16, 10),
                  child: const Text('Homes'),
                ),
                ...appMenuItems.map((item) => ListTile(
                      leading: Icon(item.icon),
                      title: Text(item.title),
                      selected:
                          appMenuItems.indexOf(item) == widget.selectedIndex,
                      onTap: () {
                        widget
                            .onDestinationSelected(appMenuItems.indexOf(item));
                      },
                    )),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
