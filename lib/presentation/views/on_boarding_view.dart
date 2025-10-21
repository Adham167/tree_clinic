import 'package:flutter/material.dart';
import 'package:tree_clinic/core/constants/assets.dart';
import 'package:tree_clinic/core/widgets/custom_floating_button.dart';
import 'package:tree_clinic/presentation/models/on_boarding_model.dart';
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
    return Scaffold(
      floatingActionButton: CustomFloatingButton(),
      body: Column(
        children: [
          OnboardingPageViewWidget(onboardingList: onboardingList),
        ],
      ),
    );
  }
}
