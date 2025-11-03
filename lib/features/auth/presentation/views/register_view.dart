import 'package:flutter/material.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/login_body.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/sign_up_body.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          leading: Container(),
          bottom: TabBar(
            indicatorColor: AppColors.kmainColor,
            labelColor: AppColors.kmainColor,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: AppColors.kseconderyColor,
            tabs: [Tab(child: Text("Login")), Tab(child: Text("SignUP"))],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: TabBarView(children: [LoginBody(), SignUpBody()]),
        ),
      ),
    );
  }
}
