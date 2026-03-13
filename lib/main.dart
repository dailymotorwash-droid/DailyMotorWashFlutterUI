import 'package:car_wash/providers/address_provider.dart';
import 'package:car_wash/providers/brand_provider.dart';
import 'package:car_wash/providers/search_address_provider.dart';
import 'package:car_wash/providers/service_provider.dart';
import 'package:car_wash/providers/subscription_provider.dart';
import 'package:car_wash/providers/user_provider.dart';
import 'package:car_wash/providers/vehicle_color_provider.dart';
import 'package:car_wash/providers/vehicle_model_provider.dart';
import 'package:car_wash/providers/vehicle_provider.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/utils/page_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
