// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lora_business_1/src/Widgets/inputs_text_widgets.dart';
import 'package:lora_business_1/src/repository/sing_in_repository.dart';
import 'package:lora_business_1/src/utils/CustomPopup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const int maxAttempts = 30;
  static const int lockoutTime = 24 * 60 * 60 * 1000;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ValueNotifier<String?> _nameErrorNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _emailErrorNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _passwordErrorNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<bool> _obscureTextNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureTextConfirmNotifier =
      ValueNotifier<bool>(true);
  final AuthRepository _authRepository = AuthRepository();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _emailErrorNotifier.dispose();
    _passwordErrorNotifier.dispose();
    _obscureTextNotifier.dispose();
    _obscureTextConfirmNotifier.dispose();

    super.dispose();
  }

  void signUp() async {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      _passwordErrorNotifier.value = "Las contraseñas no coinciden";
      return;
    }

    bool canShowPopup = await checkAttemptsAndShowPopup();
    if (!canShowPopup) {
      return;
    }

    const int validatedCode = 0001;
    CustomPopUp.showDigitInputPopup(context, (enteredDigits) async {
      final prefs = await SharedPreferences.getInstance();
      if (int.tryParse(enteredDigits) == validatedCode) {
        await prefs.setInt('attempts', 0);
        _isLoading.value = true;
        await _authRepository
            .signUpWithEmail(
          context,
          _emailController.text,
          _passwordController.text,
          _nameController.text,
        )
            .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${error.toString()}")),
          );
        });
      } else {
        int attempts = prefs.getInt('attempts') ?? 0;
        await updateAttempts(prefs, attempts);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Número inválido")),
        );
      }
    });
    _isLoading.value = false;
  }

  Future<bool> checkAttemptsAndShowPopup() async {
    final prefs = await SharedPreferences.getInstance();
    int attempts = prefs.getInt('attempts') ?? 0;
    int lastAttemptTime = prefs.getInt('lastAttemptTime') ?? 0;

    if (attempts >= maxAttempts &&
        DateTime.now().millisecondsSinceEpoch - lastAttemptTime < lockoutTime) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Límite de intentos alcanzado")),
      );
      return false;
    }
    return true;
  }

  updateAttempts(SharedPreferences prefs, int attempts) async {
    await prefs.setInt('attempts', attempts + 1);
    await prefs.setInt(
        'lastAttemptTime', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    bool canSignUp = _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF309975),
          centerTitle: true,
          title: const Text('Register',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: () {
              widget.showLoginPage();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        body: ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return child!;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo-nombre.png',
                      width: 200,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InputTextWidgets.inputTextWidget(
                            errorNotifier: _nameErrorNotifier,
                            inputText: "Nombre",
                            prefixIcon: const Icon(Icons.person_2_outlined),
                            inputTextController: _nameController,
                            updateState: () => setState(() {}),
                            isPassword: false),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InputTextWidgets.inputTextWidget(
                          errorNotifier: _emailErrorNotifier,
                          inputText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          inputTextController: _emailController,
                          updateState: () => setState(() {}),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InputTextWidgets.inputTextWidget(
                          errorNotifier: _passwordErrorNotifier,
                          inputText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          inputTextController: _passwordController,
                          updateState: () => setState(() {}),
                          isPassword: true,
                          obscureTextNotifier: _obscureTextNotifier,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InputTextWidgets.inputTextWidget(
                          errorNotifier: _passwordErrorNotifier,
                          inputText: "Confirm Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          inputTextController: _confirmPasswordController,
                          updateState: () => setState(() {}),
                          isPassword: true,
                          obscureTextNotifier: _obscureTextConfirmNotifier,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF309975),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: canSignUp
                            ? () {
                                signUp();
                              }
                            : null,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('I have an account!'),
                        TextButton(
                          onPressed: () {
                            widget.showLoginPage();
                          },
                          child: const Text(
                            'Login now',
                            style: TextStyle(
                              color: Color(0xFF309975),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
