import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/prediction/presentation/manager/cubit/prediction_cubit.dart';
import 'package:tree_clinic/presentation/loading_page.dart';
import 'package:tree_clinic/presentation/manager/current_user_cubit/current_user_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String selectedFruit = 'apple';
  File? imageFile;
  final picker = ImagePicker();

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrentUserCubit>().getCurrentUser();
    });
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  Future<void> pickCamera() async {
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  Future<void> pickGallery() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildButton(IconData icon, String text, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 6),
            Text(
              context.tr(text),
              style: TextStyle(
                color: Colors.green.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fruitLabel(String fruitCode) {
    return switch (fruitCode) {
      'apple' => context.tr('Apple'),
      'banana' => context.tr('Banana'),
      'guava' => context.tr('Guava'),
      'mango' => context.tr('Mango'),
      _ => fruitCode,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: Text(context.tr('Home')),
          backgroundColor: Colors.green,
          actions: const [DashBoardIcon()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green.shade100,
                ),
                child: DropdownButton<String>(
                  value: selectedFruit,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: 'apple',
                      child: Text(_fruitLabel('apple')),
                    ),
                    DropdownMenuItem(
                      value: 'banana',
                      child: Text(_fruitLabel('banana')),
                    ),
                    DropdownMenuItem(
                      value: 'guava',
                      child: Text(_fruitLabel('guava')),
                    ),
                    DropdownMenuItem(
                      value: 'mango',
                      child: Text(_fruitLabel('mango')),
                    ),
                  ],
                  onChanged: (value) => setState(() => selectedFruit = value!),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 3),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child:
                    imageFile == null
                        ? Center(child: Text(context.tr('No Image Selected')))
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(imageFile!, fit: BoxFit.cover),
                        ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildButton(Icons.camera_alt, 'Camera', pickCamera),
                  buildButton(Icons.photo, 'Gallery', pickGallery),
                  buildButton(Icons.analytics, 'Predict', () {
                    if (imageFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.tr('Select a leaf image first.'),
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => LoadingPage(),
                        transitionsBuilder:
                            (_, animation, __, child) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                      ),
                    );
                    BlocProvider.of<PredictionCubit>(context).sendImage(
                      imageFile!.path,
                      selectedFruit,
                      languageCode:
                          Localizations.localeOf(context).languageCode,
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashBoardIcon extends StatelessWidget {
  const DashBoardIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        if (state is CurrentUserLoading) {
          return const Center(child: Icon(Icons.error));
        } else if (state is CurrentUserSuccess) {
          if (state.userModel.type == 'Merchant') {
            final merchantId = FirebaseAuth.instance.currentUser?.uid;
            if (merchantId == null) {
              return IconButton(
                icon: const Icon(Icons.dashboard),
                onPressed: () {
                  GoRouter.of(context).push(AppRouter.kDashboardView);
                },
              );
            }

            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance
                      .collection('merchant_order_requests')
                      .where('merchantId', isEqualTo: merchantId)
                      .snapshots(),
              builder: (context, snapshot) {
                final pendingCount =
                    snapshot.data?.docs
                        .where(
                          (doc) =>
                              (doc.data()['status']?.toString() ?? 'pending') ==
                              'pending',
                        )
                        .length ??
                    0;
                final badgeLabel =
                    pendingCount > 99 ? '99+' : pendingCount.toString();

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.dashboard),
                      onPressed: () {
                        GoRouter.of(context).push(AppRouter.kDashboardView);
                      },
                    ),
                    if (pendingCount > 0)
                      PositionedDirectional(
                        top: 6,
                        end: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badgeLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          } else {
            return const SizedBox();
          }
        } else if (state is CurrentUserFailure) {
          return const Center(child: Icon(Icons.error));
        }
        return const SizedBox();
      },
    );
  }
}
