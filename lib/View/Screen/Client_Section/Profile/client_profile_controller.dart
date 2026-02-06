import 'package:get/get.dart';
import '../../../../Core/AppRoute/app_route.dart';

class ClientProfileController extends GetxController {
  // Observables for state management
  var isHealthSyncEnabled = true.obs;

  // Mock Data
  final String userName = "Sarah Johnson";
  final String cyclePhase = "FOLLICULAR PHASE";
  final String email = "sarah.j@bloomapp.com";
  final String birthday = "October 12, 1995";
  final String subscriptionStatus = "Premium Annual Plan";

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

  void signOut() {
    // Perform sign out
  }
}
