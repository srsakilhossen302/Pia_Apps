import 'package:get/get.dart';

class ClientPaymentController extends GetxController {
  // 0: Credit/Debit Card, 1: Apple/Google Pay
  var selectedPaymentMethod = 0.obs;

  void selectPaymentMethod(int index) {
    selectedPaymentMethod.value = index;
  }

  void confirmSubscription() {
    // Process payment logic
    Get.snackbar("Success", "Subscription Confirmed!");
    // Navigate home or success screen
  }
}
