import 'package:get/get.dart';
import '../../../../Model/Client_Section/recipe_model.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';

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
    if (recipe.value != null) {
      recipe.value!.isFavorite = !(recipe.value!.isFavorite ?? false);
      recipe.refresh();
    }
  }

  Future<void> toggleSave() async {
    if (recipe.value != null) {
      recipe.value!.isSaved = !(recipe.value!.isSaved ?? false);
      recipe.refresh();
    }
  }
}
