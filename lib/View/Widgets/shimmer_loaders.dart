import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// A single shimmer "box" — the base building block
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
    );
  }
}

/// Wraps children in a shimmer effect with app's pink base color
class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFFFE4EA),
      highlightColor: const Color(0xFFFFF8F9),
      child: child,
    );
  }
}

// ─────────────────────────────────────────
// RECIPE CARD SHIMMER (used in Home & Search)
// ─────────────────────────────────────────
class RecipeCardShimmer extends StatelessWidget {
  const RecipeCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        margin: EdgeInsets.only(bottom: 25.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              child: Container(
                width: double.infinity,
                height: 200.h,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 25.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  ShimmerBox(width: 200.w, height: 18.h),
                  SizedBox(height: 12.h),
                  // Meta row
                  Row(
                    children: [
                      ShimmerBox(width: 50.w, height: 12.h),
                      SizedBox(width: 20.w),
                      ShimmerBox(width: 50.w, height: 12.h),
                      SizedBox(width: 20.w),
                      ShimmerBox(width: 60.w, height: 12.h),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Description line 1
                  ShimmerBox(width: double.infinity, height: 13.h),
                  SizedBox(height: 6.h),
                  // Description line 2
                  ShimmerBox(width: 220.w, height: 13.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// PHASE CARD SHIMMER (used in Home top banner)
// ─────────────────────────────────────────
class PhaseCardShimmer extends StatelessWidget {
  const PhaseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        width: double.infinity,
        height: 177.h,
        color: const Color(0xFFFFE4E8),
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShimmerBox(width: 50.w, height: 50.h, borderRadius: 25),
            SizedBox(height: 12.h),
            ShimmerBox(width: 180.w, height: 24.h),
            SizedBox(height: 12.h),
            ShimmerBox(width: double.infinity, height: 14.h),
            SizedBox(height: 6.h),
            ShimmerBox(width: 250.w, height: 14.h),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

// PHASE DETAILS CARD SHIMMER

class PhaseDetailsShimmer extends StatelessWidget {
  const PhaseDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 25.h),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4E8),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: icon + title + day badge
              Row(
                children: [
                  ShimmerBox(width: 50.w, height: 50.h, borderRadius: 25),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 80.w, height: 12.h),
                        SizedBox(height: 6.h),
                        ShimmerBox(width: 160.w, height: 22.h),
                      ],
                    ),
                  ),
                  ShimmerBox(width: 56.w, height: 56.h, borderRadius: 28),
                ],
              ),
              SizedBox(height: 15.h),
              ShimmerBox(width: double.infinity, height: 14.h),
              SizedBox(height: 6.h),
              ShimmerBox(width: double.infinity, height: 14.h),
              SizedBox(height: 6.h),
              ShimmerBox(width: 200.w, height: 14.h),
              SizedBox(height: 20.h),
              // Bottom cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// HOME SCREEN FULL SHIMMER
// ─────────────────────────────────────────
class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 50.h),
          // Header placeholder
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: AppShimmer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerBox(width: 120.w, height: 32.h),
                  ShimmerBox(width: 36.w, height: 36.h, borderRadius: 18),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.h),
          const PhaseCardShimmer(),
          SizedBox(height: 25.h),
          const PhaseDetailsShimmer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                // Category title
                AppShimmer(
                  child: ShimmerBox(width: 140.w, height: 22.h),
                ),
                SizedBox(height: 15.h),
                const RecipeCardShimmer(),
                const RecipeCardShimmer(),
                const RecipeCardShimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// FAVORITES / SEARCH LIST SHIMMER
// ─────────────────────────────────────────
class RecipeListShimmer extends StatelessWidget {
  final int itemCount;
  const RecipeListShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 120.h),
      itemCount: itemCount,
      itemBuilder: (_, __) => const RecipeCardShimmer(),
    );
  }
}

// (No extension needed)
