import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Model/Client_Section/cycle_overview_model.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../../../service/api_url.dart';
import 'recipe_detail_controller.dart';

class RecipeDetailScreen extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late RecipeDetailController controller;

  @override
  void initState() {
    super.initState();
    // Use unique tag to avoid controller reuse issues
    controller = Get.put(RecipeDetailController(), tag: widget.recipe.id);
    controller.recipe.value = widget.recipe;

    // Always fetch latest details exactly once when entering screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.recipe.id != null) {
        controller.getRecipeDetails(widget.recipe.id!);
      }
    });
  }

  @override
  void dispose() {
    Get.delete<RecipeDetailController>(tag: widget.recipe.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4), // Light pink background
      body: Obx(() {
        final currentRecipe = controller.recipe.value ?? widget.recipe;
        String imageUrl = currentRecipe.image != null
            ? (currentRecipe.image!.startsWith('http')
                  ? currentRecipe.image!
                  : "${ApiConstant.baseUrl}${currentRecipe.image}")
            : 'https://via.placeholder.com/400';

        return Stack(
          children: [
            // === Top Image Section ===
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 320.h,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) =>
                        const NetworkImage('https://via.placeholder.com/400'),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // === Close Button ===
            Positioned(
              top: 50.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 20.sp, color: Colors.black),
                ),
              ),
            ),

            // === Header Content (Over Image) ===
            Positioned(
              top: 140.h,
              left: 20.w,
              right: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phase Tags
                  if (currentRecipe.phases != null &&
                      currentRecipe.phases!.isNotEmpty)
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: currentRecipe.phases!.map((tag) {
                        String iconPath = AppIcons.heartIcon;
                        if (tag.toLowerCase().contains('follicular')) {
                          iconPath = AppIcons.follicularPhase;
                        } else if (tag.toLowerCase().contains('luteal')) {
                          iconPath = AppIcons.lutealPhase;
                        } else if (tag.toLowerCase().contains('ovulation')) {
                          iconPath = AppIcons.ovulationPhase;
                        }
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFCDD2).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                iconPath,
                                height: 12.sp,
                                width: 12.sp,
                                color: Colors.black87,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                tag,
                                style: GoogleFonts.lato(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 12.h),
                  Text(
                    (currentRecipe.title ?? "").toUpperCase(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 14.sp,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "${(currentRecipe.prepTime ?? 0) + (currentRecipe.cookTime ?? 0)} min",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Icon(
                        Icons.people_outline,
                        color: Colors.white70,
                        size: 14.sp,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "${currentRecipe.servings ?? 1} servings",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Icon(
                        Icons.local_fire_department,
                        color: Colors.white70,
                        size: 14.sp,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "${currentRecipe.nutrition?.calories ?? 0} cal",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // === Scrollable White Body ===
            Padding(
              padding: EdgeInsets.only(top: 280.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.r),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 25.h, 20.w, 40.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // === Add to Favorites Button ===
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            controller.toggleFavorite();
                          },
                          icon: Icon(
                            (currentRecipe.isFavorite ?? false)
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: (currentRecipe.isFavorite ?? false)
                                ? const Color(0xFFFF8FA3)
                                : Colors.black87,
                            size: 18.sp,
                          ),
                          label: Text(
                            "Add to Favorites",
                            style: GoogleFonts.lato(
                              color: (currentRecipe.isFavorite ?? false)
                                  ? const Color(0xFFFF8FA3)
                                  : Colors.black87,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            side: BorderSide(
                              color: (currentRecipe.isFavorite ?? false)
                                  ? const Color(0xFFFF8FA3)
                                  : const Color(0xFFFFC1E3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            backgroundColor: (currentRecipe.isFavorite ?? false)
                                ? const Color(0xFFFFF0F3)
                                : Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // === Description ===
                      Text(
                        currentRecipe.description ?? "",
                        style: GoogleFonts.lato(
                          fontSize: 14.sp,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: 25.h),

                      // === Phase Benefits ===
                      if (currentRecipe.phaseBenefits != null &&
                          currentRecipe.phaseBenefits!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5F2), // Light peach/pink
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PHASE BENEFITS",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              ...currentRecipe.phaseBenefits!.entries.map((
                                entry,
                              ) {
                                return Text(
                                  "${entry.value}", // Just showing value as description
                                  style: GoogleFonts.lato(
                                    fontSize: 13.sp,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                      SizedBox(height: 25.h),

                      // === Nutrition Per Serving ===
                      if (currentRecipe.nutrition != null) ...[
                        Text(
                          "NUTRITION PER SERVING",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 14.sp,
                            color: Colors.black54,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 2.2,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 10.w,
                          children: [
                            _nutritionCard(
                              "Protein",
                              "${currentRecipe.nutrition?.protein ?? 0}g",
                            ),
                            _nutritionCard(
                              "Carbs",
                              "${currentRecipe.nutrition?.carbs ?? 0}g",
                            ),
                            _nutritionCard(
                              "Fat",
                              "${currentRecipe.nutrition?.fat ?? 0}g",
                            ),
                            _nutritionCard(
                              "Calories",
                              "${currentRecipe.nutrition?.calories ?? 0}",
                            ),
                          ],
                        ),
                        SizedBox(height: 25.h),
                      ],

                      // === Ingredients ===
                      if (currentRecipe.ingredients != null &&
                          currentRecipe.ingredients!.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "INGREDIENTS",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 16.sp,
                                color: Colors.black87,
                                letterSpacing: 0.5,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.addToGrocery();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF8FA3),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 14.sp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "Add to Grocery",
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        ...currentRecipe.ingredients!.map((ingredient) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9FA),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  size: 20.sp,
                                  color: const Color(0xFFFF8FA3),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    ingredient.name ?? "",
                                    style: GoogleFonts.lato(
                                      fontSize: 14.sp,
                                      color: const Color(0xFF333333),
                                    ),
                                  ),
                                ),
                                Text(
                                  "${ingredient.amount ?? ""} ${ingredient.unit ?? ""}",
                                  style: GoogleFonts.lato(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        SizedBox(height: 25.h),
                      ],

                      // === Instructions ===
                      if (currentRecipe.instructions != null &&
                          currentRecipe.instructions!.isNotEmpty) ...[
                        Text(
                          "INSTRUCTIONS",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16.sp,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        ...currentRecipe.instructions!.asMap().entries.map((
                          entry,
                        ) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24.w,
                                  height: 24.w,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF8FA3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "${entry.key + 1}",
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: GoogleFonts.lato(
                                      fontSize: 14.sp,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _nutritionCard(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F9),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(fontSize: 10.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
