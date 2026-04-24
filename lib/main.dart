import 'package:dmw/providers/address_provider.dart';
import 'package:dmw/providers/brand_provider.dart';
import 'package:dmw/providers/search_address_provider.dart';
import 'package:dmw/providers/service_provider.dart';
import 'package:dmw/providers/subscription_provider.dart';
import 'package:dmw/providers/subscription_vehicle_provider.dart';
import 'package:dmw/providers/transaction_provider.dart';
import 'package:dmw/providers/user_provider.dart';
import 'package:dmw/providers/vehicle_color_provider.dart';
import 'package:dmw/providers/vehicle_model_provider.dart';
import 'package:dmw/providers/vehicle_provider.dart';
import 'package:dmw/utils/NetworkService.dart';
import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:dmw/utils/page_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async{

  // 1. You MUST add this line first
  WidgetsFlutterBinding.ensureInitialized();
  final networkService = NetworkService();
  networkService.startListening();

  // 2. Wait for Firebase to load using your specific project options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => VehicleModelProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()),
        ChangeNotifierProvider(create: (_) => VehicleColorProvider()),
        ChangeNotifierProvider(create: (_) => SearchAddressProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionVehicleProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MainApp(),
    )
  );
}

class MainApp extends StatelessWidget {
  final NetworkService networkService = NetworkService();
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarWash',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        useMaterial3: true,
        applyElevationOverlayColor: true,
        scaffoldBackgroundColor: AppColors.lightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBackground,
          foregroundColor: AppColors.black,
          titleTextStyle: AppTextStyles.blackFont20Regular,
          surfaceTintColor: AppColors.darkBackground
        ),
      ),
      // 👇 IMPORTANT: wrap builder
      builder: (context, child) {
        return Stack(
          children: [
            child!,

            /// 🔴 No Internet Banner
            ValueListenableBuilder<bool>(
              valueListenable: networkService.isOffline,
              builder: (context, isOffline, _) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  top: isOffline ? 0 : -60,
                  left: 0,
                  right: 0,
                  child: _banner("No Internet Connection", Colors.red),
                );
              },
            ),

            /// 🟢 Back Online Banner
            ValueListenableBuilder<bool>(
              valueListenable: networkService.isBackOnline,
              builder: (context, show, _) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  top: show ? 0 : -60,
                  left: 0,
                  right: 0,
                  child: _banner("Back Online", Colors.green),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _banner(String text, Color color) {
    return Material(
      color: color,
      child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)
        )
    );
  }
}
