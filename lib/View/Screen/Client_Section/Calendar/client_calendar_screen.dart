import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../View/Widgets/custom_bottom_nav_bar.dart';
import 'client_calendar_controller.dart';

class ClientCalendarScreen extends StatelessWidget {
  ClientCalendarScreen({super.key});

  final ClientCalendarController controller = Get.put(
    ClientCalendarController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === Header ===
                Container(
                  width:
                      double.infinity, // Explicit width to prevent Row overflow
                  padding: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: controller.previousMonth,
                        color: Colors.black87,
                      ),
                      Obx(() {
                        // Ensure reactivity by accessing the observable
                        controller.focusedDate.value;
                        return Text(
                          controller.currentMonthName,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.black87,
                          ),
                        );
                      }),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 18),
                        onPressed: controller.nextMonth,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // === Calendar Grid ===
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Column(
                    children: [
                      // Day Labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                                .map(
                                  (day) => SizedBox(
                                    width: 40.w,
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: GoogleFonts.lato(
                                          fontSize: 12.sp,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      SizedBox(height: 15.h),
                      // Dates Grid (Mocking Feb 2026 starting on Sun Feb 1)
                      _buildCalendarGrid(),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // === Legend ===
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildLegendItem(
                            "Menstrual",
                            const Color(0xFFFFCDD2),
                          ),
                          SizedBox(width: 20.w),
                          _buildLegendItem(
                            "Follicular",
                            const Color(0xFFFFE0B2),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          _buildLegendItem(
                            "Ovulation",
                            const Color(0xFFF8BBD0),
                          ), // Simulating Ovulation color
                          SizedBox(width: 20.w),
                          _buildLegendItem(
                            "Luteal",
                            const Color(0xFFFFF3E0),
                          ), // Simulating Luteal color
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                // === Summary Header ===
                // === Summary Header ===
                Obx(
                  () => Text(
                    controller.selectedDateSummary,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Phase: Luteal (Day 20)",
                  style: GoogleFonts.lato(
                    fontSize: 14.sp,
                    color: const Color(0xFFF48FB1),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 20.h),

                // === Action Cards ===
                _buildActionCard(
                  title: "NUTRITION PLAN",
                  description:
                      "Complex carbs and magnesium-rich foods. Sweet potato bowl and dark chocolate for cravings.",
                  imageUrl:
                      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=600',
                  icon: Icons.restaurant_menu,
                ),
                SizedBox(height: 15.h),
                _buildActionCard(
                  title: "WELLNESS ACTIVITIES",
                  description:
                      "Gentle stretching, walking, and self-care routines. Focus on calming activities.",
                  imageUrl:
                      'https://images.unsplash.com/photo-1544367563-12123d8965cd?q=80&w=600',
                  icon: Icons.self_improvement,
                ),
                SizedBox(height: 15.h),
                _buildNoteCard(
                  title: "HEALTH NOTES",
                  note:
                      "\"Energy may dip. Practice self-compassion and prepare for your upcoming cycle. Stay hydrated.\"",
                  icon: Icons.note_alt_outlined,
                ),
                SizedBox(height: 100),
              ],
            ),
          ),

          // === Floating Navbar ===
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClientNavBar(selectedIndex: 1), // Index 1 for Calendar
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 12.sp,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    return Obx(() {
      // Calculate calendar logic dynamically based on focusedDate
      final focusedDate = controller.focusedDate.value;
      final daysInMonth = DateUtils.getDaysInMonth(
        focusedDate.year,
        focusedDate.month,
      );
      final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
      final int firstWeekday = firstDayOfMonth.weekday % 7; // Su=0, Mo=1...

      // Total slots: offset + days in month
      final totalSlots = firstWeekday + daysInMonth;

      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 5.w,
          childAspectRatio: 1,
        ),
        itemCount: totalSlots,
        itemBuilder: (context, index) {
          if (index < firstWeekday) {
            return const SizedBox.shrink(); // Empty slot for offset
          }

          final day = index - firstWeekday + 1;
          final date = DateTime(focusedDate.year, focusedDate.month, day);

          // Logic for requested styling:
          // "aj 6 tarikh" -> Today is the 6th.
          // "age ager sob date gula" (past dates) -> 0xFFFFEBEE
          // "agami din gula" (future dates) -> 0xFFFCE4EC

          final int todayDay = 6; // Fixed "Today" as requested

          // Apply specific colors
          Color? bgColor;
          if (day < todayDay) {
            bgColor = const Color(0xFFFFEBEE); // Past
          } else if (day > todayDay) {
            bgColor = const Color(0xFFFCE4EC); // Future
          } else {
            bgColor =
                Colors.transparent; // Today (Selected) has no fill, just border
          }

          return Obx(() {
            // For this specific request, "selection" is effectively fixed on the 6th
            // But we keep the controller logic in case they click around.
            final selectedDate = controller.selectedDate.value;

            // Override IsSelected: User said "aj ker date a ilect thakbe" (Today is selected)
            // But also we want to allow clicking?
            // The prompt implies a static view of "Today is 6th, Past is X, Future is Y".
            // Let's make the 6th the "Initial" selected, but allow moving.
            // Actually, "aj ker date a ilect thakbe" implies the visual state OF the 6th.

            // Merging selection logic:
            // If the user clicks another date, should the 6th still look 'selected'?
            // Usually 'Today' has a distinct indicator (like a dot) and 'Selected' has a circle.
            // Here, let's treat the 6th as the active highlighted day.

            bool isSelected =
                (selectedDate.day == day &&
                selectedDate.month == focusedDate.month &&
                selectedDate.year == focusedDate.year);

            // If the user hasn't clicked anything else, default 'isSelected' to 'isToday' logic if needed,
            // but the controller handles selection state.

            return GestureDetector(
              onTap: () => controller.onDateSelected(date),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.transparent : bgColor,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: const Color(0xFFF48FB1), width: 1.5)
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      "$day",
                      style: GoogleFonts.lato(
                        fontSize: 14.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        bottom: 6.h,
                        child: Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF48FB1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          });
        },
      );
    });
  }

  Widget _buildActionCard({
    required String title,
    required String description,
    required String imageUrl,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        // Pink left border accent
        border: Border(
          left: BorderSide(color: const Color(0xFFF48FB1), width: 4.w),
        ),
        boxShadow: [
          // Soft pink/warm shadow
          BoxShadow(
            color: const Color(0xFFF48FB1).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18.sp, color: const Color(0xFFF48FB1)),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(
                            0xFF2D2D2D,
                          ), // Darker, cleaner black
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    fontSize: 13.sp,
                    color: const Color(0xFF5D5D5D), // Softer grey text
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.network(
              imageUrl,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(width: 80.w, height: 80.w, color: Colors.grey[200]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard({
    required String title,
    required String note,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        // Consistent Pink left border accent
        border: Border(
          left: BorderSide(color: const Color(0xFFF48FB1), width: 4.w),
        ),
        boxShadow: [
          // Consistent Soft pink/warm shadow
          BoxShadow(
            color: const Color(0xFFF48FB1).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: const Color(0xFFF48FB1)),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            note,
            style: GoogleFonts.playfairDisplay(
              fontSize: 14.sp,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF5D5D5D),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
