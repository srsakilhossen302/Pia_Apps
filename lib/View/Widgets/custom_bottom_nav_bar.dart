import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'client_nav_controller.dart';

class ClientNavBar extends StatelessWidget {
  final int selectedIndex;

  const ClientNavBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    // Using Get.put to find or create the controller, ensuring it's available.
    // The snippet used Get.find, but Get.put is safer if not guaranteed to be upstream.
    // Given the flows, Get.put is appropriate here.
    final controller = Get.put(ClientBottomNavController());
    // FIX: Sync controller's index with the current page's index.
    // This prevents the bug where the controller thinks it's at 0 (default)
    // when we are actually at 1 (Calendar), causing navigation to Home (0) to be ignored.
    controller.selectedIndex.value = selectedIndex;

    return SafeArea(
      child: Container(
        height: 85.h,
        margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0xFFF294A8).withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navItem(Icons.home_outlined, "Home", 0, controller),
              _navItem(
                Icons.calendar_today_outlined,
                "Calendar",
                1,
                controller,
              ),
              _navItem(Icons.search, "Search", 2, controller),
              _navItem(Icons.star_border, "Favorites", 3, controller),
              _navItem(Icons.shopping_cart_outlined, "Grocery", 4, controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    int index,
    ClientBottomNavController controller,
  ) {
    // Logic matches snippet: Use passed selectedIndex to determine state
    final bool isSelected = selectedIndex == index;

    // Design remains "Floating Pill" as per previous styling
    const Color pinkColor = Color(0xFFF294A8);
    const Color unselectedColor = Color(0xFFF48FB1);

    if (isSelected) {
      return GestureDetector(
        onTap: () => controller.changeIndex(index),
        child: Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: pinkColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 5.w),
            boxShadow: [
              BoxShadow(
                color: pinkColor.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 28.sp),
        ),
      );
    }

    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: unselectedColor, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.playfairDisplay(
                color: unselectedColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
