import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lora_business_1/src/auth/models/user_model.dart';
import 'package:lora_business_1/src/utils/validator.dart';

class AuthRepository {
  Future<void> signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(context, e);
    } catch (e) {
      _handleGeneralException(context, e);
    }
  }

  Future<void> signUpWithEmail(
      BuildContext context, String email, String password, String name) async {
    if (!Validator.esCorreoValido(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Correo electrónico inválido")));
      return;
    }
    if (!Validator.esContrasenaValida(password)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("La contraseña debe tener al menos 6 caracteres")));
    }
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await _createUserInFirebase(context, email, password, name);
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No hay conexión a Internet")));
    }
  }

  Future<void> _createUserInFirebase(
      BuildContext context, String email, String password, String name) async {
    try {
      var userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );

      UserModel newUser = UserModel(
        email: email.trim(),
        password: password.trim(),
        lastName: "",
        name: name.trim(),
        uid: userCredential.user!.uid,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toJson());

      print('User added to Firestore');
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(context, e);
    } catch (e) {
      _handleGeneralException(context, e);
    }
  }

  void _handleFirebaseAuthException(
      BuildContext context, FirebaseAuthException e) {
    String errorMessage = "Error: ${e.message}";
    if (e.code == 'user-not-found') {
      errorMessage = "Usuario no encontrado";
    } else if (e.code == 'wrong-password') {
      errorMessage = "Contraseña incorrecta";
    } else if (e.code == 'email-already-in-use') {
      errorMessage = "El correo ya está en uso";
    } else if (e.code == "Password should be at least 6 characters") {
      errorMessage = "La contraseña debe tener al menos 6 caracteres";
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  void _handleGeneralException(BuildContext context, dynamic e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}
