import 'package:flutter/material.dart';
import 'package:lora_business_1/src/view/apartments_views/apartments_page.dart';
import 'package:lora_business_1/src/view/colmados_views/colmado_page.dart';
import 'package:lora_business_1/src/view/home_views/home_page_content.dart';
import 'package:lora_business_1/src/view/loessa_page.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  MainBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          label: 'Apartments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Loessa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Colmados',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: onItemTapped,
    );
  }
}

class MenuSelectionRoute extends StatelessWidget {
  final int selectedIndex;

  const MenuSelectionRoute({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return HomePageContent();
      case 1:
        return const ApartmentsPage();
      case 2:
        return const LoessaPage();
      case 3:
        return const ColmadosPage();
      default:
        return const Text("Page not found");
    }
  }
}
