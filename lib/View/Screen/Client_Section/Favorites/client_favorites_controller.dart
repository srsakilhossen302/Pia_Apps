import 'package:get/get.dart';
import '../../../../Model/Client_Section/recipe_model.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';

class ClientFavoritesController extends GetxController {
  final RxList<RecipeModel> favoriteMeals = <RecipeModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    isLoading.value = true;
    update();
    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );
      final response = await GetConnect().get(
        "${ApiConstant.baseUrl}${ApiConstant.recipe}/my-favorites",
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final recipeResponse = RecipeResponseModel.fromJson(response.body);
        favoriteMeals.assignAll(recipeResponse.data ?? []);
      } else {
        ToastHelper.showError(
          response.body['message'] ?? "Failed to load favorites",
        );
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
