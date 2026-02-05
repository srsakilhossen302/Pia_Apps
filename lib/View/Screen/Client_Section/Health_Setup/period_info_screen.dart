import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pia/Utils/AppIcons/app_icons.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import 'period_info_controller.dart';

class PeriodInfoScreen extends StatelessWidget {
  final PeriodInfoController controller = Get.put(PeriodInfoController());

  PeriodInfoScreen({super.key});

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
                SizedBox(height: 25.h),

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
                            0.2, // Step 1 of 5 approx
                        decoration: BoxDecoration(
                          color: const Color(0xFFF09AB1),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Step 1 of 5",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: const Color(0xFF4A5565),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // Icon Circle (Calendar) - Using placeholder Icon for now as asset unknown
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
                      AppIcons.pERIODINFO,

                      color: const Color(0xFFF09AB1),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Title Section
                Text(
                  "PERIOD INFO",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30.sp,
                    color: const Color(0xFFF09AB1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Tell us about your menstrual cycle",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: const Color(0xFF364153), // Dark gray
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 30.h),

                // Main Form Card
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Last Period Start Date
                      _buildLabel("Last Period Start Date"),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(
                                      0xFFF09AB1,
                                    ), // Header background color
                                    onPrimary:
                                        Colors.white, // Header text color
                                    onSurface: Colors.black, // Body text color
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            controller.updateDate(picked);
                          }
                        },
                        child: AbsorbPointer(
                          // Disable direct typing
                          child: TextFormField(
                            controller: controller.dateController,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 14.sp,
                              color: const Color(0xFF2D3142),
                            ),
                            decoration: InputDecoration(
                              hintText: "MM/DD/YYYY",
                              hintStyle: GoogleFonts.playfairDisplay(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 14.sp,
                              ),
                              suffixIcon: Image.asset(
                                AppIcons.pERIODINFO,
                                width: 30,

                                height: 30,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFFFFF9),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16.h,
                                horizontal: 20.w,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.r),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.r),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.r),
                                borderSide: const BorderSide(
                                  color: Color(0xFFF09AB1),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Dropdown: Do you use a period tracking app?
                      _buildLabel(
                        "Do you use a period tracking app? (Optional)",
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFF9),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedTrackingOption.value,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey[400],
                              ),
                              isExpanded: true,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 14.sp,
                                color: const Color(0xFF2D3142),
                              ),
                              items: controller.trackingOptions
                                  .map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  })
                                  .toList(),
                              onChanged: controller.updateTrackingOption,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Slider: Cycle Length
                      _buildLabel("Cycle Length (days)"),
                      SizedBox(height: 12.h),

                      // Value Display
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: 20.w,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFF9),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text(
                                "${controller.cycleLength.value.toInt()}",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2D3142),
                                ),
                              ),
                            ),
                            Text(
                              "days",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 16.sp,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Slider
                      Obx(
                        () => SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFFF09AB1),
                            inactiveTrackColor: const Color(0xFFFFE0E6),
                            thumbColor: const Color(0xFFF09AB1),
                            overlayColor: const Color(
                              0xFFF09AB1,
                            ).withOpacity(0.2),
                            trackHeight: 6.h,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 8.r,
                            ),
                          ),
                          child: Slider(
                            value: controller.cycleLength.value.clamp(
                              21.0,
                              35.0,
                            ),
                            min: 21,
                            max: 35,
                            divisions: 130,
                            label: controller.cycleLength.value
                                .round()
                                .toString(),
                            onChanged: controller.updateCycleLength,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "21 days",
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "35 days",
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 48.h),

                // Continue Button
                SafeArea(
                  child: SizedBox(
                    width: double.infinity,
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
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.playfairDisplay(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2D3142),
      ),
    );
  }
}
