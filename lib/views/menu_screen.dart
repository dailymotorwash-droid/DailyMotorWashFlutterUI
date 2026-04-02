import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_map_classes.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:dmw/utils/page_routes.dart';
import 'package:dmw/views/all_saved_vehicles.dart';
import 'package:dmw/views/profile_screen.dart';
import 'package:dmw/views/saved_vehicles_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/custom_enums.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<MenuOption> menuOptions = const [
    MenuOption(
        icon: Icons.person,
        label: 'Edit Profile',
        route: AppRoutes.profileScreen),
    MenuOption(
        icon: Icons.car_crash,
        label: 'Manage Vehicles',
        route: AppRoutes.allSavedVehicles),
    MenuOption(
        icon: Icons.home,
        label: 'Manage Addresses',
        route: AppRoutes.savedAddressScreen),
    // MenuOption(
    //     icon: Icons.notifications,
    //     label: 'Notifications',
    //     route: AppRoutes.notificationScreen),
    MenuOption(
        icon: Icons.payment,
        label: 'Transactions',
        route: AppRoutes.transactionsScreen),
    MenuOption(icon: Icons.help, label: 'Help', route: AppRoutes.helpScreen),
    MenuOption(
        icon: Icons.logout, label: 'Sign Out', route: AppRoutes.loginScreen),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MENU',
          style: AppTextStyles.primaryFont20Regular,
        ),
        backgroundColor: AppColors.darkBackground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ...List.generate(menuOptions.length, (index) {
            return InkWell(
              onTap: () {
                if (index != menuOptions.length) {
                  debugPrint(menuOptions[index].route);
                  if (AppRoutes.loginScreen == menuOptions[index].route) {
                    Navigator.pushNamedAndRemoveUntil(context,
                        AppRoutes.loginScreen, (Route<dynamic> route) => false);
                    return;
                  } else if (AppRoutes.helpScreen == menuOptions[index].route) {
                    _launchWhatsApp();
                    return;
                  }
                  Navigator.pushNamed(context, menuOptions[index].route);
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Row(
                  children: [
                    Icon(menuOptions[index].icon, size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Text(
                      menuOptions[index].label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.blackFont20Regular,
                    ))
                  ],
                ),
              ),
            );
          }),
        ]),
      ),
    );
  }

  Future<void> _launchWhatsApp() async {
    const String phoneNumber =
        "917838495927"; // Include country code, no '+' or '-'
    const String message = "Hi! I need some help.";

    // Encode the message to handle spaces and special characters
    final String url =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode
            .externalApplication, // Forces it to open the WhatsApp app
      );
    } else {
      // Handle the error (e.g., WhatsApp not installed)
      print("Could not launch WhatsApp");
    }
  }
}
