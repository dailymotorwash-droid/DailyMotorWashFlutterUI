import 'package:car_wash/views/add_vehicle_screen.dart';
import 'package:car_wash/views/all_saved_vehicles.dart';
import 'package:car_wash/views/error_route_scrren.dart';
import 'package:car_wash/views/address_screen.dart';
import 'package:car_wash/views/help_screen.dart';
import 'package:car_wash/views/landing_screen.dart';
import 'package:car_wash/views/login_screen.dart';
import 'package:car_wash/views/notifications_screen.dart';
import 'package:car_wash/views/profile_screen.dart';
import 'package:car_wash/views/saved_address_screen.dart';
import 'package:car_wash/views/saved_vehicles_screen.dart';
import 'package:car_wash/views/splash_screen.dart';
import 'package:car_wash/views/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:car_wash/views/home_screen/home_screen.dart';

class AppRoutes {
  static const loginScreen = "/login_screen";
  static const profileScreen = "/profile_screen";
  static const addressScreen = "/address_screen";
  static const splashScreen = "/splash_screen";
  static const homeScreen = "/home_scrren";
  static const errorRouteScreen = "/error_route_screeen";
  static const addVehicleScreen = "/add_vehicle_screen";
  static const landingScreen = "/landing_screen";
  static const notificationScreen = "/notification_screen";
  static const savedAddressScreen = "/saved_address_screen";
  static const savedVehiclesScreen = "/saved_vehicles_screen";
  static const helpScreen = "/help_screen";
  static const allSavedVehicles = "/allSavedVehicles";
  static const transactionsScreen = "/transactions_screen";
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    
    switch (settings.name) {
      case AppRoutes.loginScreen:
        return buildRoute(const LoginScreen(), settings: settings);

      case AppRoutes.allSavedVehicles:
        return buildRoute(const AllSavedVehicles(), settings: settings);

      case AppRoutes.profileScreen:
        return buildRoute(const ProfileScreen(), settings: settings);

      // case AppRoutes.addressScreen:
      //   return buildRoute(const AddressScreen(), settings: settings);

      case AppRoutes.splashScreen:
        return buildRoute(const SplashScreen(), settings: settings);

      case AppRoutes.homeScreen:
        return buildRoute(const HomeScreen(), settings: settings);

      case AppRoutes.landingScreen:
        return buildRoute(const LandingScreen(), settings: settings);

      case AppRoutes.addVehicleScreen:
        return buildRoute(const AddVehicleScreen(), settings: settings);


      case AppRoutes.notificationScreen:
        return buildRoute(const NotificationsScreen(), settings: settings);

      case AppRoutes.savedAddressScreen:
        return buildRoute(const SavedAddressScreen(), settings: settings);

      // case AppRoutes.savedVehiclesScreen:
      //   return buildRoute(const SavedVehiclesScreen(), settings: settings);

      case AppRoutes.helpScreen:
        return buildRoute(const HelpScreen(), settings: settings);

      case AppRoutes.transactionsScreen:
        return buildRoute(const TransactionsScreen(), settings: settings);

      default:
        return buildRoute(const ErrorRouteScrren(), settings: settings);
    }
  }

  static MaterialPageRoute buildRoute(Widget child, {required RouteSettings settings}) {
    return MaterialPageRoute(settings: settings, builder: (BuildContext context) => child);
  }
}
