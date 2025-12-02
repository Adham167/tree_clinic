import 'package:flutter/material.dart';

class PredictResultPage extends StatelessWidget {
  const PredictResultPage({super.key, required this.result});
  final String result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prediction Result"),
        backgroundColor: Colors.green,
        leading: BackButton(color: Colors.white),
      ),
      body: Center(
        child: Text(result, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
