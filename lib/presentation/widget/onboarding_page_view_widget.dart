import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:tree_clinic/presentation/models/on_boarding_model.dart';

class OnboardingPageViewWidget extends StatelessWidget {
  const OnboardingPageViewWidget({
    super.key,
    required this.onboardingList,
    required this.pageController,
  });

  final List<OnBoardingModel> onboardingList;
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged:
          (index) => context.read<OnboardingCubit>().changePage(index),
      itemCount: onboardingList.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: pageController,
          builder: (context, child) {
            double value = 0;
            if (pageController.position.haveDimensions) {
              value = pageController.page! - index;
            }

            final bool isLast = index == onboardingList.length - 1;

            double parallax = value * 100;
            double scale = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);

            Widget image = Image.asset(
              onboardingList[index].image,
              fit: BoxFit.cover,
            );

            if (isLast) {
              image = Hero(tag: "onboardHero", child: image);
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                Transform.translate(
                  offset: Offset(parallax, 0),
                  child: Transform.scale(scale: scale, child: image),
                ),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                Positioned(
                  top: 50,
                  right: 20,
                  child: TextButton(
                    onPressed:
                        () => context.read<OnboardingCubit>().nextPage(context),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 80,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),

                      Text(
                        onboardingList[index].title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        onboardingList[index].description,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.6,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
