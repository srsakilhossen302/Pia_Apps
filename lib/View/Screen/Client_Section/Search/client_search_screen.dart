import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Model/Client_Section/meal_model.dart';
import '../../../Widgets/custom_bottom_nav_bar.dart';
import '../Home/meal_detail_screen.dart';
import 'client_search_controller.dart';

class ClientSearchScreen extends StatelessWidget {
  ClientSearchScreen({super.key});

  final ClientSearchController controller = Get.put(ClientSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4), // Light pink background
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // === Header / Safe Area ===
                  SizedBox(height: 10.h),
                  // Status bar time is system handled, we just need space

                  // === Search Bar ===
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.black87,
                            size: 24.sp,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: TextField(
                              onChanged: controller.filterMeals,
                              decoration: InputDecoration(
                                hintText:
                                    "Search recipes by name or ingredient...",
                                hintStyle: GoogleFonts.playfairDisplay(
                                  color: Colors.grey[600],
                                  fontSize: 14.sp,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: GoogleFonts.playfairDisplay(
                                color: Colors.black87,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // === Filter Button ===
                  SizedBox(height: 15.h),
                  // === Filter Button ===
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: controller.toggleFilterVisibility,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFF48FB1).withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: const Color(0xFFF48FB1),
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Filters",
                              style: GoogleFonts.playfairDisplay(
                                color: const Color(0xFFF48FB1),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // === Expandable Filter Section ===
                  Obx(() {
                    if (!controller.isFilterVisible.value)
                      return const SizedBox.shrink();

                    return Container(
                      margin: EdgeInsets.only(
                        top: 15.h,
                        left: 20.w,
                        right: 20.w,
                      ),
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FILTERS",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Cycle Phase
                          _buildFilterLabel("Cycle Phase"),
                          _buildDropdown(controller.selectedPhase.value, [
                            "All phases",
                            "Menstrual",
                            "Follicular",
                            "Ovulation",
                            "Luteal",
                          ]),
                          SizedBox(height: 15.h),

                          // Meal Type
                          _buildFilterLabel("Meal Type"),
                          _buildDropdown(controller.selectedMealType.value, [
                            "All types",
                            "Breakfast",
                            "Lunch",
                            "Dinner",
                            "Snack",
                          ]),
                          SizedBox(height: 15.h),

                          // Max Calories
                          _buildFilterLabel("Max Calories"),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFFF8F8,
                              ), // Very light pink/white
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: TextField(
                              controller: controller.maxCaloriesController,
                              decoration: InputDecoration(
                                hintText: "e.g., 500",
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.grey[400],
                                ),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(height: 15.h),

                          // How You're Feeling
                          _buildFilterLabel("How You're Feeling"),
                          _buildDropdown(controller.selectedFeeling.value, [
                            "Select feeling",
                            "Energetic",
                            "Tired",
                            "Bloated",
                            "Cramping",
                          ], isFeeling: true),
                          SizedBox(height: 15.h),

                          // Nutrients
                          _buildFilterLabel("Nutrients"),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children:
                                [
                                  "Iron",
                                  "Calcium",
                                  "Protein",
                                  "Fiber",
                                  "Omega-3",
                                  "Magnesium",
                                  "Vitamin C",
                                ].map((nutrient) {
                                  return Obx(() {
                                    final isSelected = controller
                                        .selectedNutrients
                                        .contains(nutrient);
                                    return GestureDetector(
                                      onTap: () =>
                                          controller.toggleNutrient(nutrient),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFFF48FB1)
                                              : const Color(0xFFFFF8F8),
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                        child: Text(
                                          nutrient,
                                          style: GoogleFonts.lato(
                                            fontSize: 12.sp,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                }).toList(),
                          ),
                        ],
                      ),
                    );
                  }),

                  // === Result Count ===
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Obx(
                        () => Text(
                          "${controller.searchResults.length} recipes found",
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.grey[700],
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15.h),

                  // === Recipe List ===
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        20.w,
                        0,
                        20.w,
                        120.h,
                      ), // Bottom padding for navbar
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) {
                        final meal = controller.searchResults[index];
                        return _buildSearchMealCard(context, meal);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // === Bottom Navbar ===
          // Hide navbar when keyboard is open to prevent it from floating up
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClientNavBar(selectedIndex: 2),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchMealCard(BuildContext context, MealModel meal) {
    return GestureDetector(
      onTap: () {
        // Navigate to Meal Detail
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
                // Top Left Badge (Icons)
                Positioned(
                  top: 15.h,
                  left: 15.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF48FB1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.spa, color: Colors.black87, size: 12.sp),
                        SizedBox(width: 4.w),
                        // Add another icon if needed to match "two droplets" look
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.black87,
                          size: 12.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                // Top Right Actions
                Positioned(
                  top: 15.h,
                  right: 15.w,
                  child: Row(
                    children: [
                      _buildCircleIcon(Icons.star_border), // Star
                      SizedBox(width: 8.w),
                      _buildCircleIcon(Icons.bookmark_border), // Bookmark
                    ],
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

                  // Meta Info Row
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

  Widget _buildCircleIcon(IconData icon) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, size: 18.sp, color: Colors.black87),
      ),
    );
  }

  Widget _buildFilterLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: GoogleFonts.playfairDisplay(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> items, {
    bool isFeeling = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F8),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
          dropdownColor: Colors.white,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.lato(fontSize: 14.sp, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue == null) return;
            // Map values back to controller based on label logic if needed,
            // or we can make the helper accept a callback.
            // For simplicity in this stateless widget, we'll access controller directly
            // by checking which list 'items' matches, or better, pass the RxString or callback.

            // To be safe and clean without passing callbacks everywhere in this quick edit:
            if (isFeeling) {
              controller.selectedFeeling.value = newValue;
            } else if (items.contains("Menstrual")) {
              // Phase list
              controller.selectedPhase.value = newValue;
            } else {
              // Meal Type list
              controller.selectedMealType.value = newValue;
            }
          },
        ),
      ),
    );
  }
}
