import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pia/Utils/AppIcons/app_icons.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import 'exercise_level_controller.dart';

class ExerciseLevelScreen extends StatelessWidget {
  final ExerciseLevelController controller = Get.put(ExerciseLevelController());

  ExerciseLevelScreen({super.key});

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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 50.h),

                // Header: HEALTH SETUP & Skip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "HEALTH SETUP",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24.sp,
                        color: const Color(0xFFF09AB1), // Pink title
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.skip,
                      child: Text(
                        "Skip",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: const Color(0xFF4A5565),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Progress Bar
                Container(
                  width: double.infinity,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width:
                            MediaQuery.of(context).size.width *
                            0.6, // Step 3 of 5 approx
                        decoration: BoxDecoration(
                          color: const Color(0xFFF09AB1),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Step 3 of 5",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: const Color(0xFF4A5565),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // Icon Circle (Pulse)
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF09AB1).withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      AppIcons.exerciseLevel,
                      width: 32.w,
                      color: const Color(
                        0xFFF09AB1,
                      ), // Tinting if needed, or source is colored
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Title Section
                Text(
                  "EXERCISE LEVEL",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24.sp,
                    color: const Color(0xFFF09AB1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "How active are you on a typical day?",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: const Color(0xFF364153),
                  ),
                ),
                SizedBox(height: 30.h),

                // Main Form Card (List of Options)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 32.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF09AB1).withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Obx(
                    () => Column(
                      children: controller.options.map((option) {
                        bool isSelected =
                            controller.selectedLevel.value == option["title"];
                        return GestureDetector(
                          onTap: () => controller.selectLevel(option["title"]!),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFFF0F5)
                                  : Colors.white, // Light pink if selected
                              borderRadius: BorderRadius.circular(
                                30.r,
                              ), // Pill shape as per image
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFF09AB1)
                                    : const Color(0xFFEEEEEE),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Radio Circle
                                Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? const Color(0xFFF09AB1)
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFF09AB1)
                                          : const Color(0xFFE5E7EB),
                                      width: 1,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Icon(
                                            Icons.circle,
                                            size: 8.sp,
                                            color: Colors.white,
                                          ),
                                        ) // Inner white dot style
                                      : null,
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 14.sp,
                                        color: const Color(0xFF2D3142),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: option["title"]!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(text: "  "),
                                        TextSpan(
                                          text: option["subtitle"]!,
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF6B7280),
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                SizedBox(height: 48.h),

                // Bottom Buttons (Back & Continue)
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: controller.back,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF2D3142),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                side: const BorderSide(color: Colors.white),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Back",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: controller.nextStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF09AB1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Continue",
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.sp,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
