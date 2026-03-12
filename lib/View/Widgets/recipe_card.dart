import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Model/Client_Section/cycle_overview_model.dart';
import '../../Utils/AppIcons/app_icons.dart';
import '../../service/api_url.dart';
import '../Screen/Client_Section/Home/recipe_detail_screen.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final bool isFavoritePage;
  final VoidCallback? onFavoriteTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.isFavoritePage = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl = recipe.image != null
        ? (recipe.image!.startsWith('http')
            ? recipe.image!
            : "${ApiConstant.baseUrl}${recipe.image}")
        : 'https://via.placeholder.com/400';

    return GestureDetector(
      onTap: () {
        Get.to(() => RecipeDetailScreen(recipe: recipe));
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
                    imageUrl,
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      height: 160.h,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                // Top Left Badge (Phases)
                if (recipe.phases != null && recipe.phases!.isNotEmpty)
                  Positioned(
                    top: 15.h,
                    left: 15.w,
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: recipe.phases!.map((tag) {
                        String iconPath = AppIcons.heartIcon;
                        if (tag.toLowerCase().contains('follicular')) {
                          iconPath = AppIcons.follicularPhase;
                        } else if (tag.toLowerCase().contains('luteal')) {
                          iconPath = AppIcons.lutealPhase;
                        } else if (tag.toLowerCase().contains('ovulation')) {
                          iconPath = AppIcons.ovulationPhase;
                        }
                        return Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFCDD2).withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            iconPath,
                            height: 14.sp,
                            width: 14.sp,
                            color: Colors.black87,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                // Top Right Action (Heart)
                Positioned(
                  top: 15.h,
                  right: 15.w,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          (recipe.isFavorite == true || isFavoritePage)
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          size: 18.sp,
                          color: (recipe.isFavorite == true || isFavoritePage)
                              ? const Color(0xFFFF8FA3)
                              : Colors.black87,
                        ),
                      ),
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
                    (recipe.title ?? "").toUpperCase(),
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
                        "${(recipe.prepTime ?? 0) + (recipe.cookTime ?? 0)}m",
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
                        "${recipe.servings ?? 1} servings",
                        style: GoogleFonts.lato(
                          fontSize: 12.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "${recipe.nutrition?.calories ?? 0} cal",
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
                    recipe.description ?? "",
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
