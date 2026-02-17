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
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Transform.rotate(
          angle: 3.1415,
          child: Icon(Icons.arrow_back_ios, size: 24, color: Colors.black),
        ),
      ),
    );
  }
}
