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
      backgroundColor: const Color(0xFFFFF6F7),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "GROCERY",
          style: GoogleFonts.playfairDisplay(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          // Content Layer
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFF48FB1)))
                    : SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // === YOUR LISTS ===
                            _buildSectionTitle("YOUR LISTS"),
                            SizedBox(height: 12.h),

                            _buildInputRow(
                              controller: controller.newListController,
                              hint: "New list name...",
                              onAdd: controller.createList,
                            ),
                            SizedBox(height: 15.h),

                            ...controller.groceryLists.map((list) => _buildListCard(list)),

                            SizedBox(height: 30.h),

                            // === PANTRY ===
                            _buildSectionTitle("PANTRY", icon: Icons.inventory_2_outlined),
                            SizedBox(height: 12.h),

                            _buildInputRow(
                              controller: controller.newPantryItemController,
                              hint: "Add to pantry...",
                              onAdd: controller.addPantryItem,
                            ),
                            SizedBox(height: 15.h),

                            // Pantry Items List
                            if (controller.pantryItems.isEmpty)
                              _buildEmptyState("Pantry is empty")
                            else
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(5.w),
                                child: Wrap(
                                  spacing: 8.w,
                                  runSpacing: 10.h,
                                  children: controller.pantryItems
                                      .map((item) => _buildPantryChip(item))
                                      .toList(),
                                ),
                              ),

                            SizedBox(height: 30.h),

                            // === CURRENT LIST ===
                            if (controller.selectedList.value != null) ...[
                              _buildSectionTitle(
                                controller.selectedList.value!.title.toUpperCase(),
                                icon: Icons.shopping_bag_outlined,
                              ),
                              SizedBox(height: 12.h),

                              _buildInputRow(
                                controller: controller.newItemController,
                                hint: "Add item...",
                                onAdd: controller.addItem,
                              ),
                              SizedBox(height: 20.h),

                              if (controller.selectedList.value!.items.isEmpty)
                                _buildEmptyState("No items in this list")
                              else
                                Column(
                                  children: controller.selectedList.value!.items
                                      .map((item) => _buildGroceryItemRow(item))
                                      .toList(),
                                ),
                            ] else ...[
                              _buildEmptyState("Please select or create a list"),
                            ],

                            SizedBox(height: 160.h), // Safe scrolling space
                          ],
                        ),
                      ),
              ),
            ),
          ),

          // Nav Bar Layer - Fixed to absolute bottom
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClientNavBar(selectedIndex: 4),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: const Color(0xFFF48FB1), size: 18.sp),
          SizedBox(width: 8.w),
        ],
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D2D2D),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildInputRow({
    required TextEditingController controller,
    required String hint,
    required VoidCallback onAdd,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: TextField(
                controller: controller,
                textAlignVertical: TextAlignVertical.center,
                style: GoogleFonts.lato(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.lato(color: Colors.grey[400], fontSize: 13.sp),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: 45.h,
            height: 45.h,
            decoration: const BoxDecoration(
              color: Color(0xFFF48FB1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildListCard(dynamic list) {
    bool isSelected = controller.selectedList.value?.id == list.id;
    return GestureDetector(
      onTap: () => controller.selectedList.value = list,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF48FB1).withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: isSelected ? Border.all(color: const Color(0xFFF48FB1).withOpacity(0.5)) : null,
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFFF48FB1) : Colors.black87,
                    ),
                  ),
                  Text(
                    "${list.items.length} items",
                    style: GoogleFonts.lato(fontSize: 11.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, size: 20.sp, color: Colors.grey[400]),
              onPressed: () => controller.deleteList(list.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPantryChip(dynamic item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: const Color(0xFFF48FB1).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.name,
            style: GoogleFonts.lato(fontSize: 13.sp, color: Colors.black87, fontWeight: FontWeight.w400),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => controller.removePantryItem(item.id),
            child: Icon(Icons.close, size: 14.sp, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildGroceryItemRow(dynamic item) {
    bool isBought = item.isBought;
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: isBought,
            activeColor: const Color(0xFFF48FB1),
            onChanged: (val) => controller.toggleItem(item.id),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
          ),
          Expanded(
            child: Text(
              item.name,
              style: GoogleFonts.playfairDisplay(
                fontSize: 14.sp,
                color: isBought ? Colors.grey[400] : Colors.black87,
                decoration: isBought ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          // Move to Pantry
          IconButton(
            icon: Icon(Icons.inventory_2_outlined, size: 18.sp, color: const Color(0xFFF48FB1).withOpacity(0.6)),
            onPressed: () => controller.moveToPantry(item.id),
            tooltip: "Move to Pantry",
          ),
          // Delete
          IconButton(
            icon: Icon(Icons.delete_outline, size: 18.sp, color: Colors.grey[300]),
            onPressed: () => controller.deleteItem(item.id),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Text(
          message,
          style: GoogleFonts.lato(
            color: Colors.grey[400],
            fontSize: 13.sp,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
