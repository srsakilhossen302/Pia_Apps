import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Widgets/custom_bottom_nav_bar.dart';
import '../../../Widgets/recipe_card.dart';
import '../../../Widgets/shimmer_loaders.dart';
import 'client_favorites_controller.dart';

class ClientFavoritesScreen extends StatefulWidget {
  const ClientFavoritesScreen({super.key});

  @override
  State<ClientFavoritesScreen> createState() => _ClientFavoritesScreenState();
}

class _ClientFavoritesScreenState extends State<ClientFavoritesScreen>
    with RouteAware {
  late ClientFavoritesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ClientFavoritesController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload every time this screen becomes active (e.g., returned to from details)
    final route = ModalRoute.of(context);
    if (route?.isCurrent == true) {
      controller.loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4),
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
                      color: const Color(0xFFFCE4EC),
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
                      color: const Color(0xFFF48FB1),
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
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const RecipeListShimmer(itemCount: 4);
                    }
                    if (controller.favoriteMeals.isEmpty) {
                      return Center(
                        child: Text(
                          "No favorite recipes yet.",
                          style: GoogleFonts.lato(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 120.h),
                      itemCount: controller.favoriteMeals.length,
                      itemBuilder: (context, index) {
                        final recipe = controller.favoriteMeals[index];
                        return RecipeCard(recipe: recipe, isFavoritePage: true);
                      },
                    );
                  }),
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
}
