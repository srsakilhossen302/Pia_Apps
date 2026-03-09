import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Model/Client_Section/subscription_model.dart';
import '../../../Widgets/shimmer_loaders.dart';
import 'client_subscription_controller.dart';

class ClientSubscriptionScreen extends StatelessWidget {
  ClientSubscriptionScreen({super.key});

  final ClientSubscriptionController controller = Get.put(
    ClientSubscriptionController(),
  );

  // ─── Color palette ─────────────────────────────────
  static const Color _bgColor = Color(0xFFFFF3F4);
  static const Color _accentPink = Color(0xFFF48FB1);

  static const Color _darkText = Color(0xFF1A1A2E);
  static const Color _subtleText = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          Obx(
            () => controller.isLoading.value
                ? _buildShimmerLoading()
                : controller.plans.isEmpty
                    ? _buildEmptyState()
                    : _buildContent(),
          ),
          // Payment processing overlay
          Obx(
            () => controller.isProcessingPayment.value
                ? Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.w, vertical: 24.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: _accentPink,
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "Setting up payment...",
                              style: GoogleFonts.lato(
                                fontSize: 14.sp,
                                color: _darkText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  SHIMMER LOADING
  // ═══════════════════════════════════════════════════
  Widget _buildShimmerLoading() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            // App bar shimmer
            AppShimmer(
              child: Row(
                children: [
                  ShimmerBox(width: 40.w, height: 40.h, borderRadius: 20),
                  const Spacer(),
                  ShimmerBox(width: 100.w, height: 20.h),
                  const Spacer(),
                  SizedBox(width: 40.w),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            // Header shimmer
            AppShimmer(
              child: Column(
                children: [
                  ShimmerBox(width: 60.w, height: 60.h, borderRadius: 30),
                  SizedBox(height: 16.h),
                  ShimmerBox(width: 200.w, height: 24.h),
                  SizedBox(height: 10.h),
                  ShimmerBox(width: 260.w, height: 14.h),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            // Card shimmers
            ...List.generate(
              2,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: AppShimmer(
                  child: Container(
                    width: double.infinity,
                    height: 320.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  MAIN CONTENT
  // ═══════════════════════════════════════════════════
  Widget _buildContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Custom SliverAppBar ──
        SliverAppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          pinned: true,
          expandedHeight: 0,
          leading: _buildBackButton(),
          centerTitle: true,
          title: Text(
            "Subscription",
            style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: _darkText,
            ),
          ),
        ),

        // ── Header Section ──
        SliverToBoxAdapter(
          child: _buildHeader(),
        ),

        // ── Plan Toggle / Info ──
        SliverToBoxAdapter(
          child: SizedBox(height: 25.h),
        ),

        // ── Plan Cards ──
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final plan = controller.plans[index];
                final isRecommended = plan.name.contains("Pro");
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 500 + (index * 200)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: _buildPlanCard(plan, isRecommended, index),
                );
              },
              childCount: controller.plans.length,
            ),
          ),
        ),

        // ── Footer ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
            child: Column(
              children: [
                _buildSecurityBadge(),
                SizedBox(height: 15.h),
                Text(
                  "Cancel anytime. No hidden fees.",
                  style: GoogleFonts.lato(
                    fontSize: 13.sp,
                    color: _subtleText,
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════
  //  BACK BUTTON
  // ═══════════════════════════════════════════════════
  Widget _buildBackButton() {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16.sp,
            color: _darkText,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  HEADER SECTION
  // ═══════════════════════════════════════════════════
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          // Crown / Premium Icon with gradient background
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF8BBD0), Color(0xFFFFA776)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _accentPink.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 36.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "Upgrade to Premium",
            style: GoogleFonts.playfairDisplay(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              color: _darkText,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Unlock all features and get the most out\nof your wellness journey",
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 14.sp,
              color: _subtleText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  PLAN CARD
  // ═══════════════════════════════════════════════════
  Widget _buildPlanCard(
      SubscriptionPlanModel plan, bool isRecommended, int index) {
    final Color cardAccent = plan.primaryColor;
    final Color lightAccent = cardAccent.withOpacity(0.08);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 22.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            border: isRecommended
                ? Border.all(color: cardAccent.withOpacity(0.4), width: 1.8)
                : Border.all(color: Colors.grey.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: isRecommended
                    ? cardAccent.withOpacity(0.12)
                    : Colors.black.withOpacity(0.04),
                blurRadius: isRecommended ? 25 : 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Top accent strip ──
              Container(
                height: 4.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isRecommended
                        ? [cardAccent, cardAccent.withOpacity(0.4)]
                        : [cardAccent.withOpacity(0.3), cardAccent.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 25.h),
                child: Column(
                  children: [
                    // ── Plan Name ──
                    Text(
                      plan.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: _darkText,
                        letterSpacing: 1.5,
                      ),
                    ),

                    if (plan.description.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Text(
                        plan.description,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 12.sp,
                          color: _subtleText,
                          height: 1.4,
                        ),
                      ),
                    ],

                    SizedBox(height: 18.h),

                    // ── Price Section ──
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 28.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: lightAccent,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "\$",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: cardAccent,
                            ),
                          ),
                          Text(
                            plan.price == plan.price.toInt()
                                ? plan.price.toInt().toString()
                                : plan.price.toStringAsFixed(2),
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 38.sp,
                              fontWeight: FontWeight.bold,
                              color: cardAccent,
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h, left: 3.w),
                            child: Text(
                              plan.formattedInterval,
                              style: GoogleFonts.lato(
                                fontSize: 14.sp,
                                color: cardAccent.withOpacity(0.65),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Trial Period Badge ──
                    if (plan.trialPeriodDays > 0) ...[
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.card_giftcard_rounded,
                                size: 14.sp, color: const Color(0xFF4CAF50)),
                            SizedBox(width: 6.w),
                            Text(
                              "${plan.trialPeriodDays}-day free trial",
                              style: GoogleFonts.lato(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 22.h),

                    // ── Divider ──
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.08),
                    ),

                    SizedBox(height: 20.h),

                    // ── Features List ──
                    ...plan.features
                        .map((feature) => _buildFeatureItem(feature, cardAccent)),

                    // ── Extra info row (team & services) ──
                    if (plan.maxTeamMembers > 1 || plan.maxServices > 0) ...[
                      SizedBox(height: 15.h),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey.withOpacity(0.08),
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          if (plan.maxTeamMembers > 1)
                            Expanded(
                              child: _buildInfoChip(
                                Icons.group_outlined,
                                "Up to ${plan.maxTeamMembers} members",
                                cardAccent,
                              ),
                            ),
                          if (plan.maxTeamMembers > 1 && plan.maxServices > 0)
                            SizedBox(width: 10.w),
                          if (plan.maxServices > 0)
                            Expanded(
                              child: _buildInfoChip(
                                Icons.miscellaneous_services_outlined,
                                "${plan.maxServices} services",
                                cardAccent,
                              ),
                            ),
                        ],
                      ),
                    ],

                    SizedBox(height: 25.h),

                    // ── CTA Button ──
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isRecommended
                                ? [cardAccent, cardAccent.withOpacity(0.8)]
                                : [cardAccent.withOpacity(0.85), cardAccent],
                          ),
                          borderRadius: BorderRadius.circular(26.r),
                          boxShadow: [
                            BoxShadow(
                              color: cardAccent.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => controller.selectPlan(plan),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                plan.price == 0
                                    ? "Get Started Free"
                                    : "Choose ${plan.name.split(' ').last}",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Recommended Badge ──
        if (isRecommended)
          Positioned(
            top: -13.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 7.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cardAccent, cardAccent.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: cardAccent.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded,
                        size: 14.sp, color: Colors.white),
                    SizedBox(width: 5.w),
                    Text(
                      "MOST POPULAR",
                      style: GoogleFonts.lato(
                        fontSize: 11.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════
  //  FEATURE ITEM
  // ═══════════════════════════════════════════════════
  Widget _buildFeatureItem(String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 22.w,
            height: 22.h,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              size: 14.sp,
              color: color,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(
                fontSize: 14.sp,
                color: const Color(0xFF374151),
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  INFO CHIP (team members, services)
  // ═══════════════════════════════════════════════════
  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 12.sp,
                color: color.withOpacity(0.85),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  SECURITY BADGE
  // ═══════════════════════════════════════════════════
  Widget _buildSecurityBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline_rounded,
              size: 16.sp, color: _subtleText),
          SizedBox(width: 8.w),
          Text(
            "Secured by Stripe",
            style: GoogleFonts.lato(
              fontSize: 13.sp,
              color: _subtleText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  EMPTY STATE
  // ═══════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return SafeArea(
      child: Column(
        children: [
          // App bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Row(
              children: [
                _buildBackButton(),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: _accentPink.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 40.sp,
                        color: _accentPink,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "No Plans Available",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: _darkText,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Subscription plans are not available right now.\nPlease check back later.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 14.sp,
                        color: _subtleText,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    TextButton.icon(
                      onPressed: () => controller.getSubscriptionPlans(),
                      icon: Icon(Icons.refresh_rounded,
                          size: 18.sp, color: _accentPink),
                      label: Text(
                        "Retry",
                        style: GoogleFonts.lato(
                          fontSize: 14.sp,
                          color: _accentPink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
