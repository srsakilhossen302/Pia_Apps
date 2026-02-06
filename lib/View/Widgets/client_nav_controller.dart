import 'package:get/get.dart';
import 'package:pia/Core/AppRoute/app_route.dart';

class ClientBottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;

    switch (index) {
      case 0:
        Get.offAllNamed(AppRoute.homeScreen);
        break;
      case 1:
        Get.offAllNamed(AppRoute.clientCalendarScreen);
        break;
      case 2:
        Get.offAllNamed(AppRoute.clientSearchScreen);
        break;
      case 3:
        Get.offAllNamed(AppRoute.clientFavoritesScreen);
        break;
      case 4:
        Get.offAllNamed(AppRoute.clientGroceryScreen);
        break;
    }
  }
}
