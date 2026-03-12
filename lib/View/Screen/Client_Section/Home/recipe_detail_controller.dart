import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import '../../../../Model/Client_Section/cycle_overview_model.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';
import 'client_home_controller.dart';
import '../Favorites/client_favorites_controller.dart';

class RecipeDetailController extends GetxController {
  final Rx<RecipeModel?> recipe = Rx<RecipeModel?>(null);
  final RxBool isLoading = false.obs;

  Future<void> getRecipeDetails(String id) async {
    isLoading.value = true;
    update();
    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );
      debugPrint("Fetching details for ID: $id");

      final response = await GetConnect().get(
        "${ApiConstant.baseUrl}${ApiConstant.recipe}/$id",
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint("Get Details Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        dynamic responseData = response.body;

        if (responseData is String) {
          try {
            responseData = jsonDecode(responseData);
          } catch (e) {
            debugPrint("Error decoding response: $e");
          }
        }

        if (responseData is Map) {
          try {
            final mappedData = Map<String, dynamic>.from(responseData);
            if (mappedData.containsKey('data')) {
              final singleRecipeResponse = SingleRecipeResponseModel.fromJson(
                mappedData,
              );
              // Only update if data is not null to preserve existing data (like ID)
              if (singleRecipeResponse.data != null) {
                recipe.value = singleRecipeResponse.data;
              }
            } else {
              recipe.value = RecipeModel.fromJson(mappedData);
            }
          } catch (e) {
            debugPrint("Parsing Error: $e");
          }
        }

        recipe.refresh();
        _syncWithHomeController();
      } else {
        // Don't show error for details fetch failure to avoid disrupting user experience
        debugPrint("Failed to load details: ${response.body}");
      }
    } catch (e) {
      debugPrint("Network error details: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void _syncWithHomeController() {
    try {
      if (Get.isRegistered<ClientHomeController>() && recipe.value != null) {
        final homeController = Get.find<ClientHomeController>();
        if (homeController.cycleOverview.value?.recipes != null) {
          bool found = false;
          homeController.cycleOverview.value!.recipes!.forEach((
            category,
            list,
          ) {
            final index = list.indexWhere(
              (element) => element.id == recipe.value!.id,
            );
            if (index != -1) {
              list[index].isFavorite = recipe.value!.isFavorite;
              found = true;
            }
          });
          if (found) {
            homeController.cycleOverview.refresh();
          }
        }
      }
    } catch (e) {
      debugPrint("Sync error: $e");
    }
  }

  Future<void> toggleFavorite() async {
    if (recipe.value == null || recipe.value?.id == null) {
      ToastHelper.showError("Error: Recipe ID is missing");
      return;
    }

    final String recipeId = recipe.value!.id!;
    final originalStatus = recipe.value!.isFavorite;

    // Optimistic Update
    recipe.value!.isFavorite = !(originalStatus ?? false);
    recipe.refresh();
    _syncWithHomeController();
    _syncWithFavoritesController();

    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );

      if (token == null || token.isEmpty) {
        _revertFavorite(originalStatus);
        ToastHelper.showError("Authentication failed: No token");
        return;
      }

      // debugPrint("Toggling favorite for: $recipeId");
      final url =
          "${ApiConstant.baseUrl}${ApiConstant.recipe}/$recipeId/favorite";

      final response = await GetConnect().post(
        url,
        {}, // Sending empty body
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint("Fav API: ${response.statusCode} - ${response.bodyString}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic responseData = response.body;

        // Handle String response
        if (responseData is String) {
          try {
            responseData = jsonDecode(responseData);
          } catch (e) {
            debugPrint("JSON Decode error: $e");
          }
        }

        // Check for server-side success flag if present
        if (responseData is Map && responseData.containsKey('success')) {
          if (responseData['success'] == false) {
            _revertFavorite(originalStatus);
            ToastHelper.showError(
              responseData['message'] ?? "Operation failed",
            );
            return;
          }
        }

        // Success Feedback
        String msg = (recipe.value!.isFavorite == true)
            ? "Added to favorites"
            : "Removed from favorites";
        if (responseData is Map && responseData['message'] != null) {
          msg = responseData['message'];
        }
        ToastHelper.showSuccess(msg);

        // Update state from server response if available
        bool? serverIsFavorite;
        if (responseData is Map && responseData.containsKey('data')) {
          final data = responseData['data'];
          if (data is Map && data.containsKey('isFavorite')) {
            var isFav = data['isFavorite'];
            if (isFav is bool) {
              serverIsFavorite = isFav;
            } else if (isFav is String) {
              serverIsFavorite = isFav.toLowerCase() == 'true';
            } else if (isFav is int) {
              serverIsFavorite = isFav == 1;
            }
          }
        }

        if (serverIsFavorite != null) {
          if (recipe.value!.isFavorite != serverIsFavorite) {
            recipe.value!.isFavorite = serverIsFavorite;
            recipe.refresh();
            _syncWithHomeController();
            _syncWithFavoritesController();
          }
        }
      } else {
        // Revert on HTTP error
        _revertFavorite(originalStatus);
        String errorMsg = "Failed (${response.statusCode})";
        if (response.body is Map && response.body['message'] != null) {
          errorMsg = response.body['message'];
        }
        ToastHelper.showError(errorMsg);
      }
    } catch (e) {
      _revertFavorite(originalStatus);
      ToastHelper.showError("Connection error: $e");
      debugPrint("Toggle Exception: $e");
    }
  }

  void _revertFavorite(bool? originalStatus) {
    recipe.value!.isFavorite = originalStatus;
    recipe.refresh();
    _syncWithHomeController();
    _syncWithFavoritesController();
  }

  void _syncWithFavoritesController() {
    try {
      if (Get.isRegistered<ClientFavoritesController>() &&
          recipe.value != null) {
        final favController = Get.find<ClientFavoritesController>();
        final recipeId = recipe.value!.id;
        final isFav = recipe.value!.isFavorite ?? false;

        if (!isFav) {
          // Remove from favorites list immediately
          favController.favoriteMeals.removeWhere((r) => r.id == recipeId);
        } else {
          // Add back if not already in list
          final exists = favController.favoriteMeals.any(
            (r) => r.id == recipeId,
          );
          if (!exists && recipe.value != null) {
            favController.favoriteMeals.insert(0, recipe.value!);
          }
        }
      }
    } catch (e) {
      debugPrint("Favorites sync error: $e");
    }
  }

  var selectedListId = "".obs;
  String tempIngredientName = ""; // To store the clicked ingredient name

  Future<void> addToGrocery(String ingredientName) async {
    tempIngredientName = ingredientName;
    isLoading.value = true;
    update();

    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );

      // Fetching all grocery lists (GET /api/v1/grocery)
      final url = "${ApiConstant.baseUrl}${ApiConstant.grocery}";
      debugPrint("Fetching Grocery Lists for selection: $url");

      final response = await GetConnect().get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic responseData = response.body['data'];
        _showListSelectionPopup(responseData);
      } else {
        ToastHelper.showError("Failed to fetch grocery lists");
        debugPrint("Fetch error: ${response.statusCode}");
      }
    } catch (e) {
      ToastHelper.showError("Connection error: $e");
      debugPrint("Exception: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void _showListSelectionPopup(dynamic data) {
    selectedListId.value = ""; // Reset selection when opening
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Grocery List",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D2D2D),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Which list would you like to add these ingredients to?",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20.h),
              
              if (data != null && data is List) ...[
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300.h),
                  child: Obx(() {
                    // Accessing the observable at the top to prevent "Improper use of GetX" error
                    final currentSelectedId = selectedListId.value; 
                    
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: data.length,
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final list = data[index];
                        final bool isSelected = currentSelectedId == list['_id'];
                        
                        return GestureDetector(
                          onTap: () {
                            selectedListId.value = list['_id'] ?? "";
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFF8FA3).withOpacity(0.12) : const Color(0xFFFFF9FA),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFFF8FA3) : const Color(0xFFFFE4E8),
                                width: isSelected ? 1.8 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.check_circle : Icons.radio_button_off,
                                  size: 22.sp,
                                  color: const Color(0xFFFF8FA3),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    list['title'] ?? "Untitled List",
                                    style: GoogleFonts.lato(
                                      fontSize: 14.sp,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      color: isSelected ? const Color(0xFFFF8FA3) : const Color(0xFF444444),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ] else ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Text("No lists found", style: GoogleFonts.lato(color: Colors.grey)),
                ),
              ],
              
              SizedBox(height: 25.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: const BorderSide(color: Color(0xFFFF8FA3)),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.lato(
                          color: const Color(0xFFFF8FA3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: selectedListId.value.isEmpty ? null : () {
                        addIngredientToList(selectedListId.value);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8FA3),
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        "Add Grocery",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> addIngredientToList(String groceryId) async {
    isLoading.value = true;
    update();
    Get.back(); // Close selection popup

    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );

      // Final API call: POST /api/v1/grocery/{groceryId}/items
      final url = "${ApiConstant.baseUrl}${ApiConstant.grocery}/$groceryId/items";
      debugPrint("Adding Item to List: $url");
      debugPrint("Payload: {'name': '$tempIngredientName'}");

      final response = await GetConnect().post(
        url,
        {"name": tempIngredientName},
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastHelper.showSuccess("Added $tempIngredientName to list!");
      } else {
        ToastHelper.showError("Failed to add item");
        debugPrint("Add Item error: ${response.statusCode} - ${response.bodyString}");
      }
    } catch (e) {
      ToastHelper.showError("Connection error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
