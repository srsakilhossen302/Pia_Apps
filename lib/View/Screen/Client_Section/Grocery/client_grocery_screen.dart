import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Widgets/custom_bottom_nav_bar.dart';
import 'client_grocery_controller.dart';

class ClientGroceryScreen extends StatelessWidget {
  ClientGroceryScreen({super.key});

  final ClientGroceryController controller = Get.put(ClientGroceryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4), // Light pink background
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === YOUR LISTS ===
                  Text(
                    "YOUR LISTS",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2D2D2D),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // New List Input
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: TextField(
                            controller: controller.newListController,
                            decoration: InputDecoration(
                              hintText: "New list name...",
                              hintStyle: GoogleFonts.lato(
                                color: Colors.grey[400],
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        width: 45.h,
                        height: 45.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF48FB1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),

                  // Existing List Card
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "My Grocery List",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "6 items",
                                style: GoogleFonts.lato(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.edit_outlined,
                          size: 20.sp,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.delete_outline,
                          size: 20.sp,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // === PANTRY ===
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: const Color(0xFFF48FB1),
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "PANTRY",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16.sp,
                          color: const Color(0xFF2D2D2D),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),

                  // Pantry Item
                  Obx(
                    () => Column(
                      children: controller.pantryItems
                          .map(
                            (item) => Container(
                              margin: EdgeInsets.only(bottom: 10.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 14.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Icon(
                                    Icons.close,
                                    size: 18.sp,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // === MY GROCERY LIST Header ===
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: const Color(0xFFF48FB1),
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "MY GROCERY LIST",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16.sp,
                          color: const Color(0xFF2D2D2D),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),

                  // Add Item Input
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: TextField(
                            controller: controller.newItemController,
                            decoration: InputDecoration(
                              hintText: "Add item...",
                              hintStyle: GoogleFonts.playfairDisplay(
                                color: Colors.grey[500],
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: controller.addItem,
                        child: Container(
                          height: 45.h,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF48FB1),
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  "Add",
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // === Grocery Items List ===
                  Obx(
                    () => Column(
                      children: List.generate(
                        controller.currentListItems.length,
                        (index) {
                          final item = controller.currentListItems[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: GestureDetector(
                              onTap: () => controller.toggleItem(index),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: item.isChecked
                                      ? const Color(0xFFFFF0F3)
                                      : Colors.white, // Pinkish if checked
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  children: [
                                    // Checkbox
                                    Container(
                                      width: 24.w,
                                      height: 24.w,
                                      decoration: BoxDecoration(
                                        color: item.isChecked
                                            ? const Color(0xFFF48FB1)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: item.isChecked
                                              ? const Color(0xFFF48FB1)
                                              : Colors.grey[300]!,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: item.isChecked
                                          ? Icon(
                                              Icons.check,
                                              size: 16.sp,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 15.w),

                                    // Name
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 15.sp,
                                          color: item.isChecked
                                              ? Colors.grey[500]
                                              : Colors.black87,
                                          decoration: item.isChecked
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor: const Color(
                                            0xFFF48FB1,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Actions
                                    Container(
                                      width: 32.w,
                                      height: 32.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.inventory_2_outlined,
                                        size: 16.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    GestureDetector(
                                      onTap: () => controller.removeItem(index),
                                      child: Icon(
                                        Icons.delete_outline,
                                        size: 20.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 200.h), // Space for navbar
                ],
              ),
            ),
          ),

          // === Bottom Navbar ===
          // Hide navbar when keyboard is open
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClientNavBar(selectedIndex: 4),
            ),
        ],
      ),
    );
  }
}
