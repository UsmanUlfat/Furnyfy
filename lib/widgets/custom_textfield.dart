import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomTextfield extends StatelessWidget {
  final IconData icon;
  final bool obscureText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator; // Validation function

  const CustomTextfield({
    Key? key,
    required this.icon,
    required this.obscureText,
    required this.hintText,
    required this.controller,
    this.validator, // Optional validation function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: Constants.blackColor,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(
          icon,
          color: Constants.blackColor.withOpacity(.3),
        ),
        hintText: hintText,
      ),
      cursorColor: Constants.blackColor.withOpacity(.5),
      validator: validator, // Apply validation function
    );
  }
}
