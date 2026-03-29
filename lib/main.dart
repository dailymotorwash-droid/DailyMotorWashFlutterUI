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
      child: const MainApp(), 
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
    );
  }
}
