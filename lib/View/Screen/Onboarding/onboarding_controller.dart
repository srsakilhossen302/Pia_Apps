import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../Auth/Sign_In/sign_in_screen.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  final PageController pageController = PageController();

  final List<Map<String, String>> onboardingData = [
    {
      "subtitle": "MENSTRUAL PHASE",
      "title": "NOURISH YOUR BODY",
      "description":
          "Get personalized meal plans that align with your menstrual cycle phases for optimal nutrition and wellness.",
      "icon": AppIcons.heartIcon,
    },
    {
      "subtitle": "OVULATION PHASE",
      "title": "TRACK YOUR CYCLE",
      "description":
          "Easily track your cycle with our beautiful calendar and know exactly which phase you're in at any time.",
      "icon": AppIcons.ovulationPhase,
    },
    {
      "subtitle": "FOLLICULAR PHASE",
      "title": "DISCOVER RECIPES",
      "description":
          "Browse hundreds of delicious recipes tailored to each phase, complete with nutritional benefits and cooking tips.",
      "icon": AppIcons.follicularPhase,
    },
    {
      "subtitle": "LUTEAL PHASE",
      "title": "PLAN & SAVE",
      "description":
          "Save your favorite recipes, create grocery lists, and plan your meals effortlessly throughout your cycle.",
      "icon": AppIcons.lutealPhase,
    },
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Save onboarding completion status
      SharePrefsHelper.setBool(SharedPreferenceValue.isOnboarding, true);
      // Navigate to Sign In screen
      Get.offAll(() => SignInScreen());
    }
  }

  void skip() {
    // Save onboarding completion status
    SharePrefsHelper.setBool(SharedPreferenceValue.isOnboarding, true);
    // Navigate to Sign In screen directly
    Get.offAll(() => SignInScreen());
  }
}
