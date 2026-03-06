import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Model/Client_Section/cycle_overview_model.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../../../Core/AppRoute/app_route.dart';
import '../../../../service/api_url.dart';
import '../../../Widgets/custom_bottom_nav_bar.dart';
import 'client_home_controller.dart';
import 'recipe_detail_screen.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final controller = Get.put(ClientHomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4), // Light pink background
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // === Top Safe Area & Header ===
                SizedBox(height: 50.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ASCELA",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 32.sp,
                          color: const Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.0,
                        ),
                      ),
                      // Container(
                      //   width: 40.w,
                      //   height: 40.w,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     shape: BoxShape.circle,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black.withOpacity(0.05),
                      //         blurRadius: 10,
                      //         offset: const Offset(0, 2),
                      //       ),
                      //     ],
                      //   ),
                      //   child:
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.clientProfileScreen);
                        },
                        child: Image.asset(AppIcons.personIcon),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                // === Phase Card Carousel ===
                SizedBox(
                  height: 177.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // PageView
                      PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: controller.onPageChanged,
                        itemCount: controller.phases.length,
                        itemBuilder: (context, index) {
                          return _buildPhaseCard(controller.phases[index]);
                        },
                      ),

                      // Left Arrow
                      Positioned(
                        left: 10.w,
                        child: GestureDetector(
                          onTap: controller.previousPage,
                          child: Image.asset(
                            AppIcons.arrowBack,
                            height: 40.h, // Slightly smaller for balance
                            width: 40.h,
                          ),
                        ),
                      ),

                      // Right Arrow
                      Positioned(
                        right: 10.w,
                        child: GestureDetector(
                          onTap: controller.nextPage,
                          child: Image.asset(
                            AppIcons.arrowForward,
                            height: 40.h,
                            width: 40.h,
                          ),
                        ),
                      ),

                      // Dots Indicator
                      Positioned(
                        bottom: 10.h,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(controller.phases.length, (
                              index,
                            ) {
                              bool isActive =
                                  controller.currentIndex.value == index;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                width: isActive ? 35.w : 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFFFF8FA3)
                                      : Colors.black12, // Subtler dark
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                // === Conditional: Current Phase Details Card ===
                Obx(
                  () => controller.cycleOverview.value?.currentPhaseInfo != null
                      ? _buildPhaseDetailsCard(controller)
                      : const SizedBox.shrink(),
                ),

                // === Meal Categories Section ===
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Obx(() {
                    if (controller.isLoadingCycle.value) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (controller.cycleOverview.value == null || 
                        controller.cycleOverview.value!.recipes == null || 
                        controller.cycleOverview.value!.recipes!.isEmpty) {
                      return const Center(child: Text("No nutrition plan found"));
                    }
                    
                    final recipesMap = controller.cycleOverview.value!.recipes!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: recipesMap.keys.map((category) {
                        return _buildRecipeCategory(category, recipesMap[category], controller);
                      }).toList(),
                    );
                  }),
                ),
                SizedBox(height: 200.h), // Bottom padding for navbar
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClientNavBar(selectedIndex: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(ClientPhaseModel phase) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: phase.backgroundColor),
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(phase.icon, height: 50.h, width: 50.w),
              SizedBox(width: 9.w),
              Text(
                phase.title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            phase.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 15.sp,
              color: Colors.black87,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildRecipeCategory(String categoryName, List<RecipeModel>? recipes, ClientHomeController controller) {
    if (recipes == null || recipes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoryName.toUpperCase(),
              style: GoogleFonts.playfairDisplay(
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        ...recipes.map((recipe) => _buildRecipeCard(recipe)).toList(),
      ],
    );
  }

  Widget _buildRecipeCard(RecipeModel recipe) {
    return GestureDetector(
      onTap: () {
        Get.to(() => RecipeDetailScreen(recipe: recipe));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 25.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r), // More rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), // Softer shadow
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Overlays
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  child: Image.network(
                    recipe.image != null
                        ? (recipe.image!.startsWith('http')
                              ? recipe.image!
                              : "${ApiConstant.baseUrl}${recipe.image}")
                        : 'https://via.placeholder.com/400',
                    height: 200.h, // Slightly taller as per image visual
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200.h,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                // Favorite Button (Top Right)
                Positioned(
                  top: 15.h,
                  right: 15.w,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      (recipe.isFavorite ?? false)
                          ? Icons.star
                          : Icons.star_border,
                      color: (recipe.isFavorite ?? false)
                          ? const Color(0xFFFF8FA3)
                          : Colors.black87,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                20.w,
                20.h,
                20.w,
                25.h,
              ), // More padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (recipe.title ?? "").toUpperCase(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF333333),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Meta Info (Time, People, Calories)
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16.sp,
                        color: Colors.black87, // Darker icons
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "${(recipe.prepTime ?? 0) + (recipe.cookTime ?? 0)}m",
                        style: GoogleFonts.lato(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Icon(
                        Icons.people_outline,
                        size: 18.sp,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "${recipe.servings ?? 0}",
                        style: GoogleFonts.lato(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        "${recipe.nutrition?.calories ?? 0} cal",
                        style: GoogleFonts.lato(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold, // Boldest
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  Text(
                    recipe.description ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.merriweather(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      height: 1.6,
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

  Widget _buildPhaseDetailsCard(ClientHomeController controller) {
    final phaseInfo = controller.cycleOverview.value?.currentPhaseInfo;
    if (phaseInfo == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 25.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE4E8), // Light pink background
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Icon, Title, Day Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Circle
                Container(
                  height: 50.w,
                  width: 50.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF8FA3), // Darker pink for icon bg
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.suit_heart_fill,
                    size: 24.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                // Title Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Current Phase",
                        style: GoogleFonts.lato(
                          fontSize: 12.sp,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        phaseInfo.phase?.toUpperCase() ?? "UNKNOWN",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFF8FA3), // Pink title
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Day Badge
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF8FA3),
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Day",
                        style: GoogleFonts.lato(
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${phaseInfo.day ?? 0}",
                        style: GoogleFonts.lato(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            // Description
            Text(
              phaseInfo.healthNotes ?? "",
              style: GoogleFonts.lato(
                fontSize: 14.sp,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            if (phaseInfo.nutrition != null) ...[
              SizedBox(height: 10.h),
              Text(
                "Nutrition: ${phaseInfo.nutrition}",
                style: GoogleFonts.lato(
                  fontSize: 13.sp,
                  color: Colors.black54,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            SizedBox(height: 20.h),
            // Bottom Info Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Next Phase",
                              style: GoogleFonts.lato(
                                fontSize: 12.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "${phaseInfo.nextPhase ?? ''} in ${phaseInfo.daysUntilNextPhase ?? 0}d",
                          style: GoogleFonts.lato(
                            fontSize: 13.sp,
                            color: const Color(0xFFFF8FA3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 14.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Phase Progress",
                              style: GoogleFonts.lato(
                                fontSize: 12.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Day ${phaseInfo.phaseProgress ?? 0}",
                          style: GoogleFonts.lato(
                            fontSize: 13.sp,
                            color: const Color(0xFFFF8FA3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
