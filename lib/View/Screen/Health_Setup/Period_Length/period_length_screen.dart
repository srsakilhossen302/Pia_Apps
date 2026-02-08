import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pia/Utils/AppIcons/app_icons.dart';
import 'package:pia/Utils/AppColors/app_colors.dart';
import 'period_length_controller.dart';

class PeriodLengthScreen extends StatelessWidget {
  final PeriodLengthController controller = Get.put(PeriodLengthController());

  PeriodLengthScreen({super.key});

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
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "HEALTH SETUP",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20.sp,
                        color: const Color(0xFFF09AB1), // Pink color
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.skip,
                      child: Text(
                        "Skip",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Progress Bar (Step 2 of 4)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    // Completed Steps (1 & 2) - Filled Pink
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF09AB1),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    // Remaining Steps - Light Background
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Step 2 of 5",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Icon Circle (Heart Icon)
              Container(
                width: 80.w,
                height: 80.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    AppIcons.heartIcon, // Using AppIcons heart icon
                    width: 40.w,
                    height: 40.h,
                    color: const Color(0xFFF09AB1),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Main Question
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  "HOW LONG DO YOUR\nPERIODS USUALLY LAST?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24.sp,
                    color: const Color(0xFFF09AB1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                "This will help us adjust your cycle",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),

              SizedBox(height: 40.h),

              // Days Picker (Scroll Wheel)
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 50.h,
                  scrollController: FixedExtentScrollController(
                    initialItem: 4,
                  ), // Index 4 -> 5 days
                  onSelectedItemChanged: (index) {
                    controller.onDaysChanged(index);
                  },
                  selectionOverlay: Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF09AB1).withOpacity(
                        0.5,
                      ), // Semi-transparent pink selection background
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  children: List.generate(31, (index) {
                    final days = index + 1;
                    return Center(
                      child: Text(
                        "$days days",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22.sp,
                          color: const Color(0xFF4A4A4A), // Dark gray for text
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 30.h),

              // Bottom Buttons (Back & Continue)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    // Back Button
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: controller.back,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF4A4A4A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            elevation: 2,
                            shadowColor: Colors.black12,
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
                    // Continue Button
                    Expanded(
                      flex:
                          2, // Continue is wider? No, image shows wider continue usually, or balanced. Let's make continue wider.
                      child: SizedBox(
                        height: 56.h,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.savePeriodLength,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF09AB1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              elevation: 5,
                              shadowColor: const Color(
                                0xFFF09AB1,
                              ).withOpacity(0.4),
                            ),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Row(
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
                                      ),
                                    ],
                                  ),
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
    );
  }
}
