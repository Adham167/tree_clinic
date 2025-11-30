import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({super.key, this.isEmailField = false, required this.label, this.iconButton, this.obscureText = false, this.onChanged});
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
        hintText: label),
    );
  }
  bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }
}
