import 'package:flutter/material.dart';

class InputTextWidgets {
  static Widget inputTextWidget({
    required ValueNotifier<String?> errorNotifier,
    required String inputText,
    required TextEditingController inputTextController,
    required VoidCallback updateState,
    Icon? prefixIcon,
    bool isPassword = false,
    ValueNotifier<bool>? obscureTextNotifier,
  }) {
    if (isPassword && obscureTextNotifier == null) {
      obscureTextNotifier = ValueNotifier<bool>(true);
    }

    return ValueListenableBuilder<String?>(
      valueListenable: errorNotifier,
      builder: (context, inputError, child) {
        if (isPassword) {
          return ValueListenableBuilder<bool>(
            valueListenable: obscureTextNotifier!,
            builder: (context, obscureText, _) {
              return buildTextFormField(
                inputTextController,
                inputText,
                prefixIcon,
                updateState,
                obscureText,
                inputError,
                obscureTextNotifier,
              );
            },
          );
        }
        return buildTextFormField(inputTextController, inputText, prefixIcon,
            updateState, false, inputError, obscureTextNotifier);
      },
    );
  }

  static TextFormField buildTextFormField(
    TextEditingController controller,
    String hintText,
    Icon? icon,
    VoidCallback updateState,
    bool obscureText,
    String? errorText,
    ValueNotifier<bool>? obscureTextNotifier,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Color(0xFF309975)),
        ),
        errorText: errorText,
        errorBorder: errorText != null
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red),
              )
            : null,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        hintText: hintText,
        prefixIcon: icon,
        suffixIcon: obscureTextNotifier != null
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  obscureTextNotifier.value = !obscureText;
                },
              )
            : null,
      ),
      onChanged: (value) {
        updateState();
      },
    );
  }
}
