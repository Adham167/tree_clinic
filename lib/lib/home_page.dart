import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tree_clinic/features/prediction/presentation/manager/cubit/prediction_cubit.dart';
import 'loading_page.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String selectedFruit = "apple";
  File? imageFile;
  final picker = ImagePicker();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  Future pickCamera() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  Future pickGallery() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
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
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(height: 6),
            Text(
              text,
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

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: Icon(Icons.dashboard),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => DashboardPage(),
                    transitionsBuilder: (_, animation, __, child) =>
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1, 0),
                            end: Offset(0, 0),
                          ).animate(animation),
                          child: child,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green.shade100,
                ),
                child: DropdownButton<String>(
                  value: selectedFruit,
                  isExpanded: true,
                  underline: SizedBox(),
                  items: [
                    DropdownMenuItem(value: "apple", child: Text("Apple")),
                    DropdownMenuItem(value: "banana", child: Text("Banana")),
                    DropdownMenuItem(value: "guava", child: Text("Guava")),
                    DropdownMenuItem(value: "mango", child: Text("Mango")),
                  ],
                  onChanged: (val) => setState(() => selectedFruit = val!),
                ),
              ),

              SizedBox(height: 20),

              // Image container
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 3),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: imageFile == null
                    ? Center(child: Text("No Image Selected"))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(imageFile!, fit: BoxFit.cover),
                      ),
              ),

              SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildButton(Icons.camera_alt, "Camera", pickCamera),
                  buildButton(Icons.photo, "Gallery", pickGallery),
                  buildButton(Icons.analytics, "Predict", () {
                     BlocProvider.of<PredictionCubit>(context).sendImage(imageFile!.path,selectedFruit);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => LoadingPage(),
                        transitionsBuilder: (_, animation, __, child) =>
                            FadeTransition(opacity: animation, child: child),
                      ),
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
