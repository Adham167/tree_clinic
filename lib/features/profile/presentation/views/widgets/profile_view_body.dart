import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/auth/data/model/user_model.dart';
import 'package:tree_clinic/features/profile/presentation/manager/app_locale_cubit.dart';
import 'package:tree_clinic/features/profile/presentation/views/widgets/info_card_widget.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white, size: 40),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              context.tr(user.type),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                InfoCardWidget(
                  icon: Icons.email,
                  title: context.tr('Email'),
                  value: user.email,
                ),
                InfoCardWidget(
                  icon: Icons.phone,
                  title: context.tr('Phone'),
                  value: user.phone,
                ),
                InfoCardWidget(
                  icon: Icons.person_outline,
                  title: context.tr('Type'),
                  value: context.tr(user.type),
                ),
                BlocBuilder<AppLocaleCubit, Locale>(
                  builder: (context, locale) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.language, color: Colors.green),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr('Language'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    context.tr(
                                      locale.languageCode == 'ar'
                                          ? 'Arabic'
                                          : 'English',
                                    ),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: locale.languageCode,
                                items: [
                                  DropdownMenuItem(
                                    value: 'en',
                                    child: Text(context.tr('English')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'ar',
                                    child: Text(context.tr('Arabic')),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value == null) return;
                                  context
                                      .read<AppLocaleCubit>()
                                      .setLanguageCode(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      // await GoogleSignIn.instance.signOut();
                      await FirebaseAuth.instance.signOut();

                      if (!context.mounted) return;
                      GoRouter.of(context).go(AppRouter.kAuthCoice);
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(
                      context.tr('Sign Out'),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
