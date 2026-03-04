import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Model/Client_Section/recipe_model.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../../../service/api_url.dart';
import 'recipe_detail_controller.dart';

class RecipeDetailScreen extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecipeDetailController());

    // Initialize with data from list view and then fetch full details
    if (controller.recipe.value == null ||
        controller.recipe.value?.id != recipe.id) {
      controller.recipe.value = recipe;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (recipe.id != null) {
          controller.getRecipeDetails(recipe.id!);
        }
      });
    }

    return Obx(() {
      final currentRecipe = controller.recipe.value ?? recipe;
      String imageUrl = currentRecipe.image != null
          ? (currentRecipe.image!.startsWith('http')
                ? currentRecipe.image!
                : "${ApiConstant.baseUrl}${currentRecipe.image}")
          : 'https://via.placeholder.com/400';

      return Scaffold(
        backgroundColor: const Color(0xFFFFF3F4), // Light pink background
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 50.h),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // === Top Image Section ===
                Container(
                  height: 256.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.r),
                    ), // Rounded Top Only
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
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.3, 1.0],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Stack(
                        children: [
                          // CLOSE BUTTON
                          Align(
                            alignment: Alignment.topRight,
                            child: SafeArea(
                              child: GestureDetector(
                                onTap: () => Get.back(),
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 20.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // CONTENT (Tags, Title, Info)
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (currentRecipe.phases != null &&
                                    currentRecipe.phases!.isNotEmpty)
                                  Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.h,
                                    children: currentRecipe.phases!.map((tag) {
                                      String iconPath = AppIcons.heartIcon;
                                      if (tag.toLowerCase().contains(
                                        'follicular',
                                      )) {
                                        iconPath = AppIcons.follicularPhase;
                                      } else if (tag.toLowerCase().contains(
                                        'luteal',
                                      )) {
                                        iconPath = AppIcons.lutealPhase;
                                      } else if (tag.toLowerCase().contains(
                                        'ovulation',
                                      )) {
                                        iconPath = AppIcons.ovulationPhase;
                                      }
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFFFCDD2,
                                          ).withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(
                                            25.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              iconPath,
                                              height: 14.sp,
                                              width: 14.sp,
                                              color: Colors.black87,
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              tag,
                                              style: GoogleFonts.lato(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                SizedBox(height: 15.h),
                                Text(
                                  (currentRecipe.title ?? "").toUpperCase(),
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 24.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.white70,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "${(currentRecipe.prepTime ?? 0) + (currentRecipe.cookTime ?? 0)}m",
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      Icon(
                                        Icons.people_outline,
                                        color: Colors.white70,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "${currentRecipe.servings} servings",
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      Icon(
                                        Icons.local_fire_department,
                                        color: Colors.white70,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "${currentRecipe.nutrition?.calories ?? 0} cal",
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // === White Body Content Section ===
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // === Buttons Section ===
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 25.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  controller.toggleFavorite();
                                },
                                icon: Icon(
                                  (currentRecipe.isFavorite ?? false)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: (currentRecipe.isFavorite ?? false)
                                      ? Colors.white
                                      : const Color(0xFFF294A8),
                                  size: 20.sp,
                                ),
                                label: Text(
                                  "Add to Favorites",
                                  style: GoogleFonts.lato(
                                    color: (currentRecipe.isFavorite ?? false)
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  side: (currentRecipe.isFavorite ?? false)
                                      ? BorderSide.none
                                      : BorderSide(
                                          color: const Color(
                                            0xFFF294A8,
                                          ).withOpacity(0.5),
                                        ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  backgroundColor:
                                      (currentRecipe.isFavorite ?? false)
                                      ? const Color(0xFFF294A8)
                                      : const Color(0xffFFF8F6),
                                  elevation: (currentRecipe.isFavorite ?? false)
                                      ? 4
                                      : 0,
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  controller.toggleSave();
                                },
                                icon: Icon(
                                  (currentRecipe.isSaved ?? false)
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: (currentRecipe.isSaved ?? false)
                                      ? Colors.white
                                      : const Color(0xFFFF8FA3),
                                  size: 20.sp,
                                ),
                                label: Text(
                                  "Save Recipe",
                                  style: GoogleFonts.lato(
                                    color: (currentRecipe.isSaved ?? false)
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  side: (currentRecipe.isSaved ?? false)
                                      ? BorderSide.none
                                      : BorderSide(
                                          color: const Color(
                                            0xFFFF8FA3,
                                          ).withOpacity(0.5),
                                        ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  backgroundColor:
                                      (currentRecipe.isSaved ?? false)
                                      ? const Color(0xFFFF8FA3)
                                      : const Color(0xffFFF8F6),
                                  elevation: (currentRecipe.isSaved ?? false)
                                      ? 4
                                      : 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // === Description ===
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          currentRecipe.description ?? "",
                          style: GoogleFonts.lato(
                            fontSize: 15.sp,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // === Phase Benefits ===
                      if (currentRecipe.phaseBenefits != null &&
                          currentRecipe.phaseBenefits!.isNotEmpty)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFF8F6),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PHASE BENEFITS",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              ...currentRecipe.phaseBenefits!.entries.map((
                                entry,
                              ) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: Text(
                                    "${entry.key}: ${entry.value}",
                                    style: GoogleFonts.lato(
                                      fontSize: 14.sp,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                      SizedBox(height: 35.h),

                      // === Nutrition Per Serving ===
                      if (currentRecipe.nutrition != null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "NUTRITION PER SERVING",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 16.sp,
                                  color: Colors.grey[700],
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                childAspectRatio: 2.5,
                                mainAxisSpacing: 15.h,
                                crossAxisSpacing: 15.w,
                                children: [
                                  _colItem(
                                    "Protein",
                                    "${currentRecipe.nutrition?.protein ?? 0}g",
                                  ),
                                  _colItem(
                                    "Carbs",
                                    "${currentRecipe.nutrition?.carbs ?? 0}g",
                                  ),
                                  _colItem(
                                    "Fat",
                                    "${currentRecipe.nutrition?.fat ?? 0}g",
                                  ),
                                  _colItem(
                                    "Calories",
                                    "${currentRecipe.nutrition?.calories ?? 0}",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 35.h),

                      // === Ingredients ===
                      if (currentRecipe.ingredients != null &&
                          currentRecipe.ingredients!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "INGREDIENTS",
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 18.sp,
                                      color: Colors.grey[800],
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF8FA3),
                                      borderRadius: BorderRadius.circular(25.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF8FA3,
                                          ).withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.shopping_cart_outlined,
                                          size: 16.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "Add to Grocery",
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              ...currentRecipe.ingredients!.map((ingredient) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 16.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF8F6),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ingredient.name ?? "",
                                          style: GoogleFonts.lato(
                                            fontSize: 16.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "${ingredient.amount ?? ""} ${ingredient.unit ?? ""}",
                                          style: GoogleFonts.lato(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                      SizedBox(height: 35.h),

                      // === Instructions ===
                      if (currentRecipe.instructions != null &&
                          currentRecipe.instructions!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "INSTRUCTIONS",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 18.sp,
                                  color: Colors.grey[800],
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              ...currentRecipe.instructions!
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    int index = entry.key + 1;
                                    String instruction = entry.value;
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 25.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 28.w,
                                            height: 28.w,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFF8FA3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              "$index",
                                              style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 18.w),
                                          Expanded(
                                            child: Text(
                                              instruction,
                                              style: GoogleFonts.lato(
                                                fontSize: 16.sp,
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
                          ),
                        ),

                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _colItem(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xffFFF8F6),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(fontSize: 12.sp, color: Colors.grey[500]),
          ),
          SizedBox(height: 6.h),
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
