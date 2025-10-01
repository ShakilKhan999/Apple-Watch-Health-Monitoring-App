import 'package:flutter/material.dart';
import 'package:surajashray/core/utils/constants/animation_path.dart';
import 'package:surajashray/features/onboarding/controller/onboarding_controller.dart';
import 'package:get/get.dart';
import 'package:surajashray/features/onboarding/widget/first_onboarding_widget.dart';
import 'package:surajashray/features/onboarding/widget/fourth_onboarding_widget.dart';
import 'package:surajashray/features/onboarding/widget/second_onboarding_widget.dart';
import 'package:surajashray/features/onboarding/widget/third_onboarding_widget.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: controller.onPageChanged,
        children: [
          FirstOnboardingWidget(
            animationWidget: Image.asset(
              AnimationPath.welcomeAnimation,
              fit: BoxFit.contain,
            ),
            title: 'onboarding_welcome_title'.tr,
            onButtonPressed: controller.nextPage,
            buttonText: 'next'.tr,
          ),

          SecondOnboardingWidget(
            animationWidget: Image.asset(
              AnimationPath.onboardingTwo,
              fit: BoxFit.contain,
            ),
            title: 'onboarding_feeling_amazing_title'.tr,
            subtitle: 'onboarding_transform_lives_subtitle'.tr,
            onButtonPressed: controller.nextPage,
            buttonText: 'next'.tr,
          ),

          ThirdOnboardingWidget(
            animationWidget: Image.asset(
              AnimationPath.onboardingThree,
              fit: BoxFit.contain,
            ),
            title: 'onboarding_small_wins_title'.tr,
            onButtonPressed: controller.nextPage,
            onSecondButtonPressed: controller.nextPage,
            buttonText: 'enable_notifications'.tr,
            buttonText2: 'maybe_later'.tr,
          ),

          FourthOnboardingWidget(
            animationWidget: Image.asset(
              AnimationPath.onboardingFour,
              fit: BoxFit.contain,
            ),
            title: 'onboarding_ready_start_title'.tr,
            subtitle: 'onboarding_profile_setup_subtitle'.tr,
            onButtonPressed: controller.nextPage,
            buttonText: 'get_started'.tr,
          ),
        ],
      ),
    );
  }
}
