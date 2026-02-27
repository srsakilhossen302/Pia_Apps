import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Onboarding/onboarding_screen.dart';
import '../Auth/Sign_In/sign_in_screen.dart';
import '../../../Utils/AppColors/app_colors.dart';
import '../../../Utils/AppIcons/app_icons.dart';
import '../../../helper/shared_prefe/shared_prefe.dart';

import '../Client_Section/Home/client_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      // Check for token first (Session Persistence)
      String token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );

      if (token.isNotEmpty) {
        // User is already logged in
        Get.offAll(() => ClientHomeScreen());
      } else {
        // Not logged in, check onboarding
        bool isOnboardingCompleted =
            await SharePrefsHelper.getBool(
              SharedPreferenceValue.isOnboarding,
            ) ??
            false;

        if (isOnboardingCompleted) {
          Get.offAll(() => SignInScreen());
        } else {
          Get.offAll(() => OnboardingScreen());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.splashColor1, AppColors.splashColor2],
          ),
        ),
        child: Center(
          child: Image.asset(
            AppIcons.splashLogo,
            width: 300.w, // Responsive width
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
