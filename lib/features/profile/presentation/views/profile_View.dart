import 'package:flutter/material.dart';
import 'package:tree_clinic/features/profile/presentation/views/widgets/user_info_bloc_builder.dart';
import '../../../../presentation/main_navigation.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // MainNavigation.of(context)?.goToHome();
          },
        ),
      ),
      body: UserInfoBlocBuilder(),
    );
  }
}
