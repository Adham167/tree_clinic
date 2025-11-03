import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/assets.dart';
import 'package:tree_clinic/core/widgets/custom_floating_button.dart';
import 'package:tree_clinic/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:tree_clinic/presentation/models/on_boarding_model.dart';
import 'package:tree_clinic/presentation/widget/onboarding_controllar.dart';
import 'package:tree_clinic/presentation/widget/onboarding_page_view_widget.dart';

class OnBoardingView extends StatelessWidget {
  OnBoardingView({super.key});

  List<OnBoardingModel> onboardingList = [
    OnBoardingModel(
      image: Assets.imagesOnboarding1,
      title: "Healthy plants",
      description:
          "Taking care of plants can be very rewarding, even if the plant is a fern and doesn’t produce fragrant flowers...",
    ),
    OnBoardingModel(
      image: Assets.imagesOnboarding2,
      title: "Healthy plants",
      description:
          "Taking care of plants can be very rewarding, even if the plant is a fern and doesn’t produce fragrant flowers...",
    ),
    OnBoardingModel(
      image: Assets.imagesOnboarding3,
      title: "Healthy plants",
      description:
          "Taking care of plants can be very rewarding, even if the plant is a fern and doesn’t produce fragrant flowers...",
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
            SizedBox(height: 100),
            BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                return OnboardingControllar(
                  currentIndex:
                      BlocProvider.of<OnboardingCubit>(context).currentPage,
                  onboardingList: onboardingList,
                );
              },
            ),
            SizedBox(height: 28),
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
