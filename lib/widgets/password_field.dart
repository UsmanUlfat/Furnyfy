import 'package:furniy_ar/utils/app_size.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PasswordRoundedTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final bool isOptional;
  final bool isPassword;
  bool obscureText;
  VoidCallback? onTogglePasswordVisibility;

  PasswordRoundedTextField({
    Key? key,
    required this.labelText,
    this.isOptional = false,
    this.hintText = "",
    this.controller,
    this.inputType,
    this.validator,
    this.isPassword = false,
    this.obscureText = false,
    this.onTogglePasswordVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            if (isOptional)
              const Text(
                " *",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xffB80000),
                  fontFamily: 'Poppins',
                ),
              ),
          ],
        ),
        5.h,
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          obscureText: obscureText, // Use the obscureText variable
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.white,
            filled: true,
            hintStyle: TextStyle(
              color: const Color(0xff5F566B).withOpacity(0.5),
              fontFamily: 'Poppins',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: Colors.white),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 192, 189, 195),
                width: 1.5,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            suffixIcon: isPassword
                ? InkWell(
                    onTap: onTogglePasswordVisibility,
                    child: Icon(
                      obscureText
                          ? Icons.visibility
                          : Icons.visibility_off_outlined,
                      color: Colors.black12,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
