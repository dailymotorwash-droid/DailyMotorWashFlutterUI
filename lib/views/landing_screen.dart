import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/views/booking_screen/bookings_screen.dart';
import 'package:dmw/views/home_screen/home_screen.dart';
import 'package:dmw/views/menu_screen.dart';
import 'package:dmw/views/wallet_screen/wallet_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({ super.key });

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  static const List<Widget> _screens = [HomeScreen(), BookingsScreen(), WalletScreen(), MenuScreen()];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 8,
            color: AppColors.primary,
          ),
          CurvedNavigationBar(
            items: const <Widget>[
              Icon(Icons.home, color: AppColors.white),
              Icon(Icons.calendar_month, color: AppColors.white,),
              Icon(Icons.wallet_rounded, color: AppColors.white,),
              Icon(Icons.menu, color: AppColors.white,)
            ],
            index: _selectedIndex,
            height: 70,
            color: AppColors.darkBackground,
            backgroundColor: AppColors.primary,
            buttonBackgroundColor: Colors.transparent,
            onTap: _handleTapNavigation,
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_month),
      //       label: 'Bookings',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.wallet),
      //       label: 'Wallet',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.menu),
      //       label: 'Menu',
      //     ),
      //   ],
      //   useLegacyColorScheme: false,
      //   landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      //   type: BottomNavigationBarType.shifting,
      //   currentIndex: _selectedIndex,
      //   onTap: _handleTapNavigation,
      // ),
      body: _screens[_selectedIndex],
    );
  }

  void _handleTapNavigation(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}