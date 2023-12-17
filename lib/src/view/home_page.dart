import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lora_business_1/src/Widgets/side_menu.dart';
import 'package:lora_business_1/src/view/apartments_views/apartments_page.dart';
import 'package:lora_business_1/src/view/apartments_views/colmado_page.dart';
import 'package:lora_business_1/src/view/loessa_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    switch (_selectedIndex) {
      case 0:
        bodyContent = homePageContent();
        break;
      case 1:
        bodyContent = const ApartmentsPage();
        break;
      case 2:
        bodyContent = const LoessaPage();
        break;
      case 3:
        bodyContent = const ColmadosPage();
        break;
      default:
        bodyContent = const Text("Page not found");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lora Business'),
      ),
      drawer: const SideMenu(),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: bodyContent,
    );
  }

  Widget homePageContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        FutureBuilder<String?>(
          future: getUserName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text('signed in as: ${snapshot.data ?? user.email!}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        MaterialButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          color: Colors.blue,
          child: const Text('Sign out'),
        ),
      ]),
    );
  }

  Future<String?> getUserName() async {
    try {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userData.data()?['name'];
    } catch (e) {
      print('Error al obtener el nombre del usuario: $e');
      return null;
    }
  }
}
