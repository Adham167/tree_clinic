import 'package:flutter/material.dart';
import 'package:tree_clinic/presentation/models/on_boarding_model.dart';

class OnboardingControllar extends StatelessWidget {
  const OnboardingControllar({
    super.key,
    required this.onboardingList,
    required this.currentIndex,
  });

  final List<OnBoardingModel> onboardingList;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            onboardingList.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 5),
              width: currentIndex == index ? 30 : 10,
              height: 4,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? Colors.black
                    : Colors.blueGrey,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}