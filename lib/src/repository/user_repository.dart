import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:lora_business_1/src/auth/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get to => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> getUserName(context, user) async {
    try {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userData.data()?['name'];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener el nombre del usuario'),
        ),
      );
      return null;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('users').add(user.toJson());
      Get.snackbar(
        "Success",
        "User created successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
        icon: const Icon(Icons.check_circle_outline_outlined),
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Error creating user: $error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
        icon: const Icon(Icons.error_outline_outlined),
      );
    }
  }
}
