import 'package:get/get.dart';
import '../../../../Model/Client_Section/recipe_model.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';
import 'client_home_controller.dart';

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
      final response = await GetConnect().get(
        "${ApiConstant.baseUrl}${ApiConstant.recipe}/$id",
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final singleRecipeResponse = SingleRecipeResponseModel.fromJson(
          response.body,
        );
        recipe.value = singleRecipeResponse.data;
      } else {
        ToastHelper.showError(
          response.body['message'] ?? "Failed to load recipe details",
        );
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> toggleFavorite() async {
    if (recipe.value == null || recipe.value?.id == null) return;

    final originalStatus = recipe.value!.isFavorite;

    // Optimistic Update: change color immediately
    recipe.value!.isFavorite = !(originalStatus ?? false);
    recipe.refresh();

    if (Get.isRegistered<ClientHomeController>()) {
      final homeController = Get.find<ClientHomeController>();
      final index = homeController.recipeList.indexWhere(
        (element) => element.id == recipe.value!.id,
      );
      if (index != -1) {
        homeController.recipeList[index].isFavorite = recipe.value!.isFavorite;
        homeController.recipeList.refresh();
      }
    }

    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );
      final response = await GetConnect().post(
        "${ApiConstant.baseUrl}${ApiConstant.recipe}/${recipe.value!.id}/favorite",
        null, // No body
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // Revert on failure
        recipe.value!.isFavorite = originalStatus;
        recipe.refresh();
        if (Get.isRegistered<ClientHomeController>()) {
          final homeController = Get.find<ClientHomeController>();
          final index = homeController.recipeList.indexWhere(
            (element) => element.id == recipe.value!.id,
          );
          if (index != -1) {
            homeController.recipeList[index].isFavorite = originalStatus;
            homeController.recipeList.refresh();
          }
        }
        ToastHelper.showError(response.body['message'] ?? "Toggle failed");
      }
    } catch (e) {
      // Revert on error
      recipe.value!.isFavorite = originalStatus;
      recipe.refresh();
      if (Get.isRegistered<ClientHomeController>()) {
        final homeController = Get.find<ClientHomeController>();
        final index = homeController.recipeList.indexWhere(
          (element) => element.id == recipe.value!.id,
        );
        if (index != -1) {
          homeController.recipeList[index].isFavorite = originalStatus;
          homeController.recipeList.refresh();
        }
      }
      ToastHelper.showError("Network error: $e");
    }
  }

  Future<void> toggleSave() async {
    if (recipe.value == null || recipe.value?.id == null) return;

    final originalStatus = recipe.value!.isSaved;

    // Optimistic Update: change color immediately
    recipe.value!.isSaved = !(originalStatus ?? false);
    recipe.refresh();

    if (Get.isRegistered<ClientHomeController>()) {
      final homeController = Get.find<ClientHomeController>();
      final index = homeController.recipeList.indexWhere(
        (element) => element.id == recipe.value!.id,
      );
      if (index != -1) {
        homeController.recipeList[index].isSaved = recipe.value!.isSaved;
        homeController.recipeList.refresh();
      }
    }

    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );
      final response = await GetConnect().post(
        "${ApiConstant.baseUrl}${ApiConstant.recipe}/${recipe.value!.id}/save",
        null, // No body
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // Revert on failure
        recipe.value!.isSaved = originalStatus;
        recipe.refresh();
        if (Get.isRegistered<ClientHomeController>()) {
          final homeController = Get.find<ClientHomeController>();
          final index = homeController.recipeList.indexWhere(
            (element) => element.id == recipe.value!.id,
          );
          if (index != -1) {
            homeController.recipeList[index].isSaved = originalStatus;
            homeController.recipeList.refresh();
          }
        }
        ToastHelper.showError(response.body['message'] ?? "Operation failed");
      }
    } catch (e) {
      // Revert on error
      recipe.value!.isSaved = originalStatus;
      recipe.refresh();
      if (Get.isRegistered<ClientHomeController>()) {
        final homeController = Get.find<ClientHomeController>();
        final index = homeController.recipeList.indexWhere(
          (element) => element.id == recipe.value!.id,
        );
        if (index != -1) {
          homeController.recipeList[index].isSaved = originalStatus;
          homeController.recipeList.refresh();
        }
      }
      ToastHelper.showError("Network error: $e");
    }
  }
}
