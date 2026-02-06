import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Model/Client_Section/meal_model.dart';
import '../../../Widgets/custom_bottom_nav_bar.dart';
import '../Home/meal_detail_screen.dart';
import 'client_favorites_controller.dart';

class ClientFavoritesScreen extends StatelessWidget {
  ClientFavoritesScreen({super.key});

  final ClientFavoritesController controller = Get.put(
    ClientFavoritesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4), // Light pink background
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(height: 20.h),

                // === Header Section ===
                Center(
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE4EC), // Very light pink
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF48FB1).withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: const Color(0xFFF48FB1), // Pink heart
                      size: 30.sp,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  "YOUR FAVORITES",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D2D2D),
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 5.h),
                Obx(
                  () => Text(
                    "${controller.favoriteMeals.length} recipes saved",
                    style: GoogleFonts.lato(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                // === Favorites List ===
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 120.h),
                      itemCount: controller.favoriteMeals.length,
                      itemBuilder: (context, index) {
                        final meal = controller.favoriteMeals[index];
                        return _buildFavoriteMealCard(context, meal);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // === Bottom Navbar ===
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClientNavBar(selectedIndex: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteMealCard(BuildContext context, MealModel meal) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MealDetailScreen(meal: meal));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Image Header ===
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  child: Image.network(
                    meal.imageUrl,
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      height: 160.h,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                // Top Left Badge
                Positioned(
                  top: 15.h,
                  left: 15.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF48FB1), // Pink pill
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.diamond_outlined,
                          color: Colors.white,
                          size: 12.sp,
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 12.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                // Top Right Action (Star)
                Positioned(
                  top: 15.h,
                  right: 15.w,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.star,
                        size: 18.sp,
                        color: const Color(0xFFF48FB1),
                      ), // Pink filled star
                    ),
                  ),
                ),
              ],
            ),

            // === Content ===
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.title.toUpperCase(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D2D2D),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Meta Info
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        meal.time,
                        style: GoogleFonts.lato(
                          fontSize: 12.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Icon(
                        Icons.people_outline,
                        size: 14.sp,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        meal.servings,
                        style: GoogleFonts.lato(
                          fontSize: 12.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        meal.calories,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 12.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    meal.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
