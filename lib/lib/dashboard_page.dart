import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.green,
        leading: BackButton(color: Colors.white),
      ),
      body: Center(child: Text("Dashboard Page")),
    );
  }
}
