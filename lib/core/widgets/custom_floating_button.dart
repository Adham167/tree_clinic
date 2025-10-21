import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      shape: CircleBorder(),
      backgroundColor: Colors.green,
      child: Icon(Icons.arrow_forward),
    );
  }
}
