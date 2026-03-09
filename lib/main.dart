import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'View/Screen/SplashScreen/splash_screen.dart';

import 'Core/AppRoute/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Stripe Setup ──
  Stripe.publishableKey = 'pk_test_YOUR_STRIPE_PUBLISHABLE_KEY'; // TODO: Replace with your actual Stripe publishable key
  await Stripe.instance.applySettings();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(439, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ASCELA',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          getPages: AppRoute.routes, // Register routes here
          home: const SplashScreen(),
        );
      },
    );
  }
}
