import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('signed in as: ${user.email!}'),
          MaterialButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            color: Colors.blue,
            child: const Text('Sign out'),
          ),
        ]),
      ),
    );
  }
}
