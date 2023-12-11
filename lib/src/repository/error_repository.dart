import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ErrorHandle {
  static handleError(error, context) {
    if (error is FirebaseAuthException &&
        error.code == 'network-request-failed') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Error de red: Por favor, verifica tu conexión a Internet")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${error.toString()}")));
    }
    return null;
  }
}
