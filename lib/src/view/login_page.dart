import 'package:flutter/material.dart';
import 'package:lora_business_1/src/repository/sing_in_repository.dart';
import 'package:lora_business_1/src/utils/validator.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegister;
  const LoginPage({super.key, required this.showRegister});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late ValueNotifier<String?> _emailErrorNotifier;
  late ValueNotifier<String?> _passwordErrorNotifier;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late ValueNotifier<bool> _obscureTextNotifier;
  final AuthRepository _authRepository = AuthRepository();

  Future signIn() async {
    bool esEmailValido = Validator.esCorreoValido(_emailController.text);
    bool esPasswordValido =
        Validator.esContrasenaValida(_passwordController.text);

    if (!esEmailValido || !esPasswordValido) {
      setState(() {
        if (!esEmailValido) {
          _emailErrorNotifier.value = "Correo inválido";
        }

        if (!esPasswordValido) {
          _passwordErrorNotifier.value =
              "La contraseña debe tener al menos 6 caracteres";
        }
      });
      return;
    }

    await _authRepository.signInWithEmail(
        context, _emailController.text, _passwordController.text);
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _obscureTextNotifier = ValueNotifier<bool>(true);
    _emailErrorNotifier = ValueNotifier<String?>(null);
    _passwordErrorNotifier = ValueNotifier<String?>(null);

    _emailController.addListener(() {
      if (_emailErrorNotifier.value != null &&
          _emailController.text.isNotEmpty) {
        setState(() {
          _emailErrorNotifier.value = null;
        });
      }
    });

    _passwordController.addListener(() {
      if (_passwordErrorNotifier.value != null &&
          _passwordController.text.isNotEmpty) {
        setState(() {
          _passwordErrorNotifier.value = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.removeListener(() {});
    _passwordController.removeListener(() {});
    _emailController.dispose();
    _passwordController.dispose();
    _obscureTextNotifier.dispose();
    _emailErrorNotifier.dispose();
    _passwordErrorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.1),
                Image.asset(
                  'assets/images/logo-nombre.png',
                  width: 200,
                ),
                const SizedBox(
                  height: 65,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ValueListenableBuilder<String?>(
                        valueListenable: _emailErrorNotifier,
                        builder: (context, emailError, child) {
                          return TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Color(0xFF309975),
                                ),
                              ),
                              errorText: emailError,
                              errorBorder: emailError != null
                                  ? OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    )
                                  : null,
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              hintText: 'Email',
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          );
                        }),
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
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _obscureTextNotifier,
                      builder: (context, obscureText, child) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            errorBorder: _passwordErrorNotifier.value != null
                                ? OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                  )
                                : null,
                            errorText: _passwordErrorNotifier.value,
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Color(0xFF309975)),
                            ),
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _obscureTextNotifier.value = !obscureText;
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '¿Olvidaste la contraseña?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF437B68),
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 0.13,
                      ),
                    )
                  ],
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
                    onPressed: _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty
                        ? () {
                            signIn();
                          }
                        : null,
                    child: const Text(
                      'Inicio de sesión',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No tienes una cuenta?',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.showRegister();
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          color: Color(0xFF309975),
                          fontSize: 16,
                          fontFamily: 'Montserrat',
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
    );
  }
}
