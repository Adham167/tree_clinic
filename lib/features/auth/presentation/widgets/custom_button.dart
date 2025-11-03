import 'package:flutter/material.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key, required this.name});
  String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green,
      ),
      height: 50,
      child: Center(
        child: Text(name, style: TextStyle(color: AppColors.kPrimaryColor, fontSize: 20)),
      ),
    );
  }
}
