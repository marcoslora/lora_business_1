class Validator {
  static bool esCorreoValido(String email) {
    return RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b').hasMatch(email);
  }

  static bool esContrasenaValida(String password) {
    return password.length >= 6;
  }
}
