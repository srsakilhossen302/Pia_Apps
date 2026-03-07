import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../View/Widgets/custom_bottom_nav_bar.dart';
import 'client_calendar_controller.dart';

class ClientCalendarScreen extends StatelessWidget {
  ClientCalendarScreen({super.key});

  final ClientCalendarController controller = Get.put(ClientCalendarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4),
      resizeToAvoidBottomInset: false, // Prevent UI shift from keyboard/insets
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value && controller.calendarData.value == null) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFFFF8FA3)));
            }
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 140.h), // Increased bottom padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === Header ===
                  _buildHeader(),

                  SizedBox(height: 20.h),

                  // === Calendar Grid ===
                  _buildCalendarGridContainer(),

                  SizedBox(height: 20.h),

                  // === Legend ===
                  _buildLegend(),

                  SizedBox(height: 30.h),

                  // === Summary Section ===
                  _buildSummarySection(),
                ],
              ),
            );
          }),

          // === Floating Navbar ===
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClientNavBar(selectedIndex: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.arrow_back_ios_new, size: 18.sp, color: Colors.black26),
          Text(
            controller.currentMonthLabel,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: const Color(0xFF2D2D2D),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.black26),
        ],
      ),
    );
  }

  Widget _buildCalendarGridContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"].map((day) => 
              SizedBox(
                width: 40.w,
                child: Center(
                  child: Text(
                    day,
                    style: GoogleFonts.lato(fontSize: 11.sp, color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                ),
              )).toList(),
          ),
          SizedBox(height: 15.h),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Obx(() {
      final calendarData = controller.calendarData.value;
      // Accessing the value here forces the Obx to track changes to selectedDate
      final selected = controller.selectedDate.value; 
      
      if (calendarData == null || calendarData.days == null) return const SizedBox.shrink();

      final firstDayOfMonth = DateTime(controller.apiYear, controller.apiMonthIndex, 1);
      final firstWeekday = firstDayOfMonth.weekday % 7; 
      final totalSlots = firstWeekday + calendarData.days!.length;

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
          if (index < firstWeekday) return const SizedBox.shrink();

          final dayData = calendarData.days![index - firstWeekday];
          final dayNum = dayData.day ?? 1;

          // Selection comparison - since we are in a single month view, matching day is safe
          final isSelected = (selected.day == dayNum);

          Color dayColor = Colors.transparent;
          if (dayData.color != null) {
            try {
              final hex = dayData.color!.replaceFirst('#', '');
              dayColor = Color(int.parse("FF$hex", radix: 16));
            } catch (e) {
              dayColor = const Color(0xFFFFE4E1);
            }
          }

          return GestureDetector(
            onTap: () {
              controller.onDateSelected(controller.apiYear, controller.apiMonthIndex, dayNum);
            },
            child: Container(
              decoration: BoxDecoration(
                color: dayColor, 
                shape: BoxShape.circle,
                border: isSelected 
                    ? Border.all(color: const Color(0xFFF48FB1), width: 2.2.w) // Thicker border
                    : null,
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: const Color(0xFFF48FB1).withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ] : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    "${dayData.day}",
                    style: GoogleFonts.lato(
                      fontSize: 14.sp, 
                      color: isSelected ? const Color(0xFFF48FB1) : Colors.black87, 
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      bottom: 5.h,
                      child: Container(
                        width: 5.w, 
                        height: 5.w, 
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
        },
      );
    });
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        children: [
          Row(
            children: [
              _buildLegendItem("Menstrual", const Color(0xFFFFC0CB)),
              SizedBox(width: 20.w),
              _buildLegendItem("Follicular", const Color(0xFFFFF0F5)),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              _buildLegendItem("Ovulation", const Color(0xFFFF69B4)),
              SizedBox(width: 20.w),
              _buildLegendItem("Luteal", const Color(0xFFFFE4E1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 12.w, height: 12.w, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4.r))),
        SizedBox(width: 8.w),
        Text(label, style: GoogleFonts.lato(fontSize: 12.sp, color: Colors.grey[700], fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Obx(() {
      if (controller.isPhaseLoading.value) {
        return const Center(child: Padding(padding: EdgeInsets.only(top: 40), child: CircularProgressIndicator(color: Color(0xFFFF8FA3))));
      }

      final phaseData = controller.phaseData.value;
      final calendarDay = controller.selectedDayCalendarInfo;

      Color phaseColor = const Color(0xFFFF8FA3);
      if (calendarDay?.color != null) {
        final hex = calendarDay!.color!.replaceFirst('#', '');
        phaseColor = Color(int.parse("FF$hex", radix: 16));
      }

      // Helper to darken colors for text readability
      Color textAccentColor = phaseColor;
      final hsl = HSLColor.fromColor(phaseColor);
      if (hsl.lightness > 0.7) {
        textAccentColor = hsl.withLightness(0.4).toColor();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Selected Date Title (e.g. MARCH 7 SUMMARY)
          Text(
            controller.selectedDateSummaryLabel,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF2D2D2D),
              letterSpacing: 0.5,
            ),
          ),
          
          if (phaseData != null) ...[
            SizedBox(height: 6.h),
            // 2. Message from Phase API (e.g. Phase: Menstrual (Day 4))
            Text(
              phaseData.message ?? "",
              style: GoogleFonts.lato(
                fontSize: 14.sp,
                color: textAccentColor, // Use darkened color
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
            
            SizedBox(height: 25.h),
            
            // 3. Nutrition Plan Card
            _buildActionCard(
              title: "NUTRITION PLAN",
              description: phaseData.nutrition ?? "No info available.",
              imageUrl: phaseData.image,
              icon: Icons.restaurant_menu,
              accentColor: textAccentColor,
            ),
            
            SizedBox(height: 15.h),
            
            // 4. Wellness Activities Card
            _buildActionCard(
              title: "WELLNESS ACTIVITIES",
              description: phaseData.wellness ?? "No info available.",
              imageUrl: null, 
              icon: Icons.self_improvement,
              accentColor: textAccentColor,
            ),
            
            SizedBox(height: 15.h),
            
            // 5. Health Notes Card
            _buildNoteCard(
              title: "HEALTH NOTES",
              note: phaseData.healthNotes ?? "No notes available.",
              icon: Icons.note_alt_outlined,
              accentColor: textAccentColor,
            ),
            
            // 6. Next Phase Progress Section
            if (phaseData.nextPhase != null) ...[
              SizedBox(height: 25.h),
              _buildPhaseProgress(
                nextPhase: phaseData.nextPhase!,
                daysUntil: phaseData.daysUntilNextPhase ?? 0,
                progress: (phaseData.phaseProgress ?? 0).toDouble(),
                color: textAccentColor,
              ),
            ],
          ] else
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Center(child: Text("Select a date to see your phase overview.")),
            ),
        ],
      );
    });
  }

  Widget _buildActionCard({required String title, required String description, String? imageUrl, required IconData icon, Color accentColor = const Color(0xFFF48FB1)}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25.r), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16.sp, color: accentColor.withOpacity(0.7)),
                    SizedBox(width: 10.w),
                    Text(title, style: GoogleFonts.playfairDisplay(fontSize: 14.sp, fontWeight: FontWeight.w900, color: const Color(0xFF2D2D2D), letterSpacing: 0.5)),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(description, style: GoogleFonts.lato(fontSize: 13.sp, color: const Color(0xFF5D5D5D), height: 1.5), maxLines: 4, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (imageUrl != null && imageUrl.isNotEmpty) ...[
            SizedBox(width: 15.w),
            ClipRRect(borderRadius: BorderRadius.circular(20.r), child: Image.network(imageUrl, width: 85.w, height: 85.w, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) =>
                    Container(width: 85.w, height: 85.w, color: Colors.grey[100]))),
          ],
        ],
      ),
    );
  }

  Widget _buildNoteCard({required String title, required String note, required IconData icon, Color accentColor = const Color(0xFFF48FB1)}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25.r), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: accentColor.withOpacity(0.7)),
              SizedBox(width: 10.w),
              Text(title, style: GoogleFonts.playfairDisplay(fontSize: 14.sp, fontWeight: FontWeight.w900, color: const Color(0xFF2D2D2D), letterSpacing: 0.5)),
            ],
          ),
          SizedBox(height: 12.h),
          Text(note, style: GoogleFonts.lato(fontSize: 13.sp, fontStyle: FontStyle.italic, color: const Color(0xFF5D5D5D), height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildPhaseProgress({
    required String nextPhase,
    required int daysUntil,
    required double progress,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "NEXT PHASE: ${nextPhase.toUpperCase()}",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              Text(
                "$daysUntil DAYS UNTIL",
                style: GoogleFonts.lato(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: color, // Use darker color
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress / 10.0, // Scale 1-10 as per user data
              minHeight: 8.h,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
