import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'home_page.dart';
import '../features/profile/presentation/profile_page.dart';
import 'shop_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  static _MainNavigationState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainNavigationState>();

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 1;
  final screens = [ProfilePage(), HomePage(), ShopPage()];

  void goToHome() {
    setState(() {
      index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: index,
        backgroundColor: Colors.transparent,
        color: Colors.green,
        buttonBackgroundColor: Colors.green.shade700,
        height: 60,
        animationDuration: Duration(milliseconds: 400),
        items: const [
          Icon(Icons.person, color: Colors.white, size: 30),
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.store, color: Colors.white, size: 30),
        ],
        onTap: (i) => setState(() => index = i),
      ),
      body: screens[index],
    );
  }
}
