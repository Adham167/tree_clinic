import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({super.key, this.ontap});
  final VoidCallback? ontap;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: ontap,
      shape: CircleBorder(),
      backgroundColor: Colors.green,
      child: Icon(Icons.arrow_forward),
    );
  }
}
