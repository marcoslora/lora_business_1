import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lora_business_1/src/repository/user_repository.dart';

class HomePageContent extends StatelessWidget {
  final UserRepository userRepository = UserRepository();
  final user = FirebaseAuth.instance.currentUser!;

  HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildUserGreeting(context),
          _buildSignOutButton(context),
        ],
      ),
    );
  }

  Widget _buildUserGreeting(BuildContext context) {
    return FutureBuilder<String?>(
      future: userRepository.getUserName(context, user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Text('signed in as: ${snapshot.data ?? user.email!}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
      },
      color: Colors.blue,
      child: const Text('Sign out'),
    );
  }
}
