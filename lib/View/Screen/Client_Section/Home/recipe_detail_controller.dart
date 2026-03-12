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
          homeController.cycleOverview.value!.recipes!.forEach((category, list) {
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
      if (Get.isRegistered<ClientFavoritesController>() && recipe.value != null) {
        final favController = Get.find<ClientFavoritesController>();
        final recipeId = recipe.value!.id;
        final isFav = recipe.value!.isFavorite ?? false;

        if (!isFav) {
          // Remove from favorites list immediately
          favController.favoriteMeals.removeWhere((r) => r.id == recipeId);
        } else {
          // Add back if not already in list
          final exists = favController.favoriteMeals.any((r) => r.id == recipeId);
          if (!exists && recipe.value != null) {
            favController.favoriteMeals.insert(0, recipe.value!);
          }
        }
      }
    } catch (e) {
      debugPrint("Favorites sync error: $e");
    }
  }

  Future<void> addToGrocery() async {
    if (recipe.value == null || recipe.value?.id == null) {
      ToastHelper.showError("Error: Recipe ID is missing");
      return;
    }

    final String recipeId = recipe.value!.id!;
    isLoading.value = true;
    update();

    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );

      final url = "${ApiConstant.baseUrl}${ApiConstant.addRecipeIngredients}";

      debugPrint("Hitting Add to Grocery API: $url");
      debugPrint("Payload: {'recipeId': '$recipeId'}");

      final response = await GetConnect().post(
        url,
        {'recipeId': recipeId},
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint("Add to Grocery Response Status: ${response.statusCode}");
      debugPrint("Add to Grocery Response Body: ${response.bodyString}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastHelper.showSuccess("Added to Grocery list!");
        print("API HIT SUCCESS: ${response.statusCode}");
      } else {
        String errorMsg = "Failed to add to grocery";
        if (response.body is Map && response.body['message'] != null) {
          errorMsg = response.body['message'];
        }
        ToastHelper.showError(errorMsg);
        print("API HIT FAILED: ${response.statusCode}");
      }
    } catch (e) {
      ToastHelper.showError("Connection error: $e");
      debugPrint("Add to Grocery Exception: $e");
      print("API HIT ERROR: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
