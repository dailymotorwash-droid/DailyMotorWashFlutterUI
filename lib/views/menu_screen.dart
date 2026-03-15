import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_map_classes.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/utils/page_routes.dart';
import 'package:car_wash/views/profile_screen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  
  const MenuScreen({ super.key });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  final List<MenuOption> menuOptions = const [
    MenuOption(icon: Icons.person, label: 'Edit Profile', route: AppRoutes.profileScreen),
    MenuOption(icon: Icons.car_crash, label: 'Manage Vechicles', route: AppRoutes.savedVehiclesScreen),
    MenuOption(icon: Icons.home, label: 'Manage Addresses', route: AppRoutes.savedAddressScreen),
    MenuOption(icon: Icons.notifications, label: 'Notifications', route: AppRoutes.notificationScreen),
    MenuOption(icon: Icons.payment, label: 'Transactions', route: AppRoutes.transactionsScreen),
    MenuOption(icon: Icons.help, label: 'Help', route: AppRoutes.helpScreen),
    MenuOption(icon: Icons.logout, label: 'Sign Out', route: AppRoutes.loginScreen),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('MENU', style: AppTextStyles.primaryFont20Regular,),
        backgroundColor: AppColors.darkBackground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...List.generate(menuOptions.length, (index) {
              return InkWell(
                onTap: () {
                  if(index != menuOptions.length) {
                    debugPrint(menuOptions[index].route);
                    if(AppRoutes.loginScreen==menuOptions[index].route){
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.loginScreen, (Route<dynamic> route) => false);
                     return;
                    }
                    Navigator.pushNamed(context, menuOptions[index].route);
                  } 
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Row(
                    children: [
                      Icon(menuOptions[index].icon, size: 24),
                      const SizedBox(width: 16),
                      Text(menuOptions[index].label, style: AppTextStyles.blackFont20Regular,)
                    ],
                  ),
                ),
              );
            }),
          ]
        ),
      ),
    );
  }
}

