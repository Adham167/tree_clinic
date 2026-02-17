import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({
    super.key,
    this.isEmailField = false,
    required this.label,
    this.iconButton,
    this.obscureText = false,
    this.onChanged,
  });
  final String label;

  final IconButton? iconButton;
  final bool? obscureText;
  final bool? isEmailField;
  final Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (isEmailField!) {
          if (!isValidEmail(value!)) {
            return 'Email is Invalid ';
          }
        } else if (value!.isEmpty) {
          return 'This Field is required';
        }
        return null;
      },
      obscureText: obscureText!,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: iconButton,
        hintText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.green.withOpacity(0.5),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.green, width: 3),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }
}

class AuthTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        suffixIcon: suffix,
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.green.withOpacity(0.5),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.green, width: 3),
        ),
      ),
    );
  }
}
