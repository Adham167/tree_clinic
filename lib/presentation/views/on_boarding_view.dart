import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/assets.dart';
import 'package:tree_clinic/core/widgets/custom_floating_button.dart';
import 'package:tree_clinic/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:tree_clinic/presentation/models/on_boarding_model.dart';
import 'package:tree_clinic/presentation/widget/onboarding_page_view_widget.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  final List<OnBoardingModel> onboardingList = const [
    OnBoardingModel(
      image: Assets.imagesOnboarding1,
      title: "Smart Agriculture",
      description:
          "Modern solutions to manage crops and improve productivity easily.",
    ),
    OnBoardingModel(
      image: Assets.imagesOnboarding2,
      title: "Crop Monitoring",
      description: "Track growth and soil condition with advanced technology.",
    ),
    OnBoardingModel(
      image: Assets.imagesOnboarding3,
      title: "Harvest Efficiently",
      description: "Organize harvest schedules and maximize farm output.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    return BlocProvider(
      create: (context) => OnboardingCubit(onboardingList, pageController),
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        floatingActionButton: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return CustomFloatingButton(
              ontap:
                  () => BlocProvider.of<OnboardingCubit>(
                    context,
                  ).nextPage(context),
            );
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: OnboardingPageViewWidget(
                pageController: pageController,
                onboardingList: onboardingList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
