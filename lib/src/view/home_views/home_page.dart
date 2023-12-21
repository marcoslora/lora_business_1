import 'package:flutter/material.dart';
import 'package:lora_business_1/src/menu/bottom_menu.dart';
import 'package:lora_business_1/src/menu/side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lora Business'),
      ),
      drawer: SideMenu(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          Navigator.of(context).pop();
          _onItemTapped(index);
        },
      ),
      bottomNavigationBar: MainBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: MenuSelectionRoute(selectedIndex: _selectedIndex),
    );
  }
}
