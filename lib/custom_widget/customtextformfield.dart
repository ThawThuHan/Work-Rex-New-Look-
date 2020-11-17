import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final Function validator;
  final TextEditingController controller;
  final bool secureText;

  MyTextFormField({
    this.hintText,
    this.keyboardType,
    this.validator,
    this.controller,
    this.secureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        autocorrect: false,
        validator: validator,
        obscureText: secureText,
        decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            )),
      ),
    );
  }
}
