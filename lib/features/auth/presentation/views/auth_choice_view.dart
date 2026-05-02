import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/constants/assets.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/core/widgets/auth_language_button.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/bottom_wave_clipper.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/floating_auth_button.dart';

class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key});

  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floating;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _floating = Tween<double>(
      begin: 0,
      end: 14,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void openLogin() {
    GoRouter.of(context).push(AppRouter.kLoginView);
  }

  void openRegister() {
    GoRouter.of(context).push(AppRouter.kSignUpView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Hero(
              tag: "onboardHero",
              child: Image.asset(Assets.imagesChoiceImage, fit: BoxFit.cover),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.65),
                  Colors.black.withOpacity(0.45),
                  Colors.black.withOpacity(0.75),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          const SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: EdgeInsetsDirectional.only(top: 18, end: 18),
                child: AuthLanguageButton(onDarkBackground: true),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 90),

                Text(
                  context.tr("Welcome"),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  context.tr(
                    "Login or create a new account to start using\n"
                    "the smart agriculture platform.",
                  ),
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.6,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                height: 210,
                width: double.infinity,
                color: Colors.green.withOpacity(0.95),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _floating,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -45 - _floating.value),
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingAuthButton(
                      icon: Icons.login,
                      text: context.tr("Login"),
                      onTap: openLogin,
                    ),
                    FloatingAuthButton(
                      icon: Icons.app_registration,
                      text: context.tr("Register"),
                      onTap: openRegister,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
