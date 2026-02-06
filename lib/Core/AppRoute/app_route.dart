import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../View/Screen/Client_Section/Home/client_home_screen.dart';
import '../../View/Screen/Client_Section/Calendar/client_calendar_screen.dart';
import '../../View/Screen/Client_Section/Search/client_search_screen.dart';
import '../../View/Screen/Client_Section/Favorites/client_favorites_screen.dart';

import '../../View/Screen/Client_Section/Grocery/client_grocery_screen.dart';
import '../../View/Screen/Client_Section/Profile/client_profile_screen.dart';
import '../../View/Screen/Client_Section/Profile/edit_profile/client_edit_profile_screen.dart';
import '../../View/Screen/Client_Section/Subscription/client_subscription_screen.dart';
import '../../View/Screen/Client_Section/Payment/client_payment_screen.dart';

class AppRoute {
  ///==================== Initial Routes ====================///
  static const String homeScreen = "/homeScreen";
  static const String clientCalendarScreen = "/clientCalendarScreen";
  static const String clientSearchScreen = "/clientSearchScreen";
  static const String clientFavoritesScreen = "/clientFavoritesScreen";
  static const String clientGroceryScreen = "/clientGroceryScreen";
  static const String clientProfileScreen = "/clientProfileScreen";
  static const String clientEditProfileScreen = "/clientEditProfileScreen";
  static const String clientSubscriptionScreen = "/clientSubscriptionScreen";
  static const String clientPaymentScreen = "/clientPaymentScreen";

  static List<GetPage> routes = [
    ///==================== Authentication  Routes ====================///
    GetPage(name: homeScreen, page: () => ClientHomeScreen()),
    GetPage(name: clientCalendarScreen, page: () => ClientCalendarScreen()),
    GetPage(name: clientSearchScreen, page: () => ClientSearchScreen()),
    GetPage(name: clientFavoritesScreen, page: () => ClientFavoritesScreen()),
    GetPage(name: clientGroceryScreen, page: () => ClientGroceryScreen()),
    GetPage(name: clientProfileScreen, page: () => ClientProfileScreen()),
    GetPage(
      name: clientEditProfileScreen,
      page: () => ClientEditProfileScreen(),
    ),
    GetPage(
      name: clientSubscriptionScreen,
      page: () => ClientSubscriptionScreen(),
    ),
    GetPage(name: clientPaymentScreen, page: () => ClientPaymentScreen()),
  ];
}
