import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'home_page.dart';
import '../features/profile/presentation/views/profile_View.dart';
import '../features/shopping/presentation/views/shop_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 1;

  final screens = const [
    ProfileView(),
    HomePage(),
    ShopPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: index,
          backgroundColor: Colors.transparent,
          color: Colors.green,
          buttonBackgroundColor: Colors.green,
          height: 60,
          animationDuration: const Duration(milliseconds: 400),
          items: const [
            Icon(Icons.person, color: Colors.white),
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.store, color: Colors.white),
          ],
          onTap: (i) => setState(() => index = i),
        ),
        body: screens[index],
      ),
    );
  }
}