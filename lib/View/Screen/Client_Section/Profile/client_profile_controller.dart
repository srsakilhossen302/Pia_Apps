import 'package:get/get.dart';
import '../../../../Core/AppRoute/app_route.dart';
import '../../../../Model/Client_Section/user_profile_model.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';
import '../../Auth/Sign_In/sign_in_screen.dart';

class ClientProfileController extends GetxController {
  // Observables for state management
  var isHealthSyncEnabled = true.obs;
  var isLoading = false.obs;

  // Profile Data
  var userProfile = Rxn<UserProfileModel>();

  @override
  void onInit() {
    super.onInit();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    isLoading.value = true;
    update();
    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );

      print("==== APP TOKEN ====");
      print(token);
      print("===================");

      final response = await GetConnect().get(
        "${ApiConstant.baseUrl}${ApiConstant.userProfile}",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final profileResponse = UserProfileResponseModel.fromJson(
          response.body,
        );
        userProfile.value = profileResponse.data;
      } else {
        ToastHelper.showError(
          response.body['message'] ?? "Failed to load profile details",
        );
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void toggleHealthSync(bool value) {
    isHealthSyncEnabled.value = value;
  }

  void editProfile() {
    Get.toNamed(AppRoute.clientEditProfileScreen);
  }

  void changePassword() {
    // Navigate to change password
  }

  void deleteAccount() {
    // Show confirmation dialog
  }

  void signOut() async {
    await SharePrefsHelper.remove(SharedPreferenceValue.token);
    await SharePrefsHelper.remove(SharedPreferenceValue.isRemember);
    Get.offAll(() => SignInScreen());
  }
}
