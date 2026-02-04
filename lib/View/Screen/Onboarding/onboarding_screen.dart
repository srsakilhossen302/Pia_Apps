import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.splashColor1, AppColors.splashColor2],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: controller.skip,
                child: Text(
                  "Skip",
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.onboardingData.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon Circle
                      Container(
                        width: 150.w,
                        height: 150.h,
                        decoration: const BoxDecoration(
                          color: Color(0xffF7D6DF),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            controller.onboardingData[index]["icon"]!,
                            width: 60.w,
                            height: 60.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Subtitle
                      Text(
                        controller.onboardingData[index]["subtitle"]!,
                        style: GoogleFonts.poppins(
                          color: const Color(
                            0xFFF395A9,
                          ), // Using red400ish color
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Title
                      Text(
                        controller.onboardingData[index]["title"]!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          // Serif font
                          color: const Color(0xFFF294A8), // Same accent pink
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Description
                      Text(
                        controller.onboardingData[index]["description"]!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF364153), // black400
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          //height: 1.2,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Indicators and Button
            Column(
              children: [
                // Indicators
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.onboardingData.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: controller.currentIndex.value == index
                            ? 24.w
                            : 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: controller.currentIndex.value == index
                              ? const Color(0xFFF395A9)
                              : const Color(0xFFD1D5DB), // Inactive color
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                // Next/Get Started Button
                SafeArea(
                  child: Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: controller.nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF294A8), // red300
                          shadowColor: Colors.black26,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.currentIndex.value ==
                                      controller.onboardingData.length - 1
                                  ? "Get Started"
                                  : "Next",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (controller.currentIndex.value ==
                                controller.onboardingData.length - 1)
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            else
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
