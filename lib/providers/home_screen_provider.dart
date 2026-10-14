import 'package:flutter/material.dart';

class HomeScreenProvider extends ChangeNotifier {
  int _selectedTab = 0; // 0: Subscription, 1: One-Time Service
  final PageController pageController = PageController(initialPage: 0);
  int get selectedTab => _selectedTab;

  void setTab(int index) {
    if (_selectedTab != index) {
      _selectedTab = index;
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
      notifyListeners();
    }
  }

  // Called continuously by PageView swipe
  void onPageChanged(int index) {
    if (_selectedTab != index) {
      _selectedTab = index;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

}