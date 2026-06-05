import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hint: Text(hintText)),
      validator: (value) {
        if (value?.isEmpty == true) {
          return '$hintText is missing!';
        }
        return null;
      },
      obscureText: isPassword,
      obscuringCharacter: '*',
    );
  }
}
