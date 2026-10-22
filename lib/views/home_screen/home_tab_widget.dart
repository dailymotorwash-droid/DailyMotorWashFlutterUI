import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_screen_provider.dart';

class HomeTabWidget extends StatelessWidget {
  const HomeTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeScreenProvider>();
    final pageController = provider.pageController;

    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width >= 600;
    final selectorHeight = isTablet ? 64.0 : 54.0;
    final padding = isTablet ? 6.0 : 4.0;
    final pillRadius = selectorHeight / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final availableWidth = totalWidth - (padding * 2);
        final tabWidth = availableWidth / 2;

        return Container(
          height: selectorHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF2B2F40),
            borderRadius: BorderRadius.circular(pillRadius),
          ),
          padding: EdgeInsets.all(padding),
          child: AnimatedBuilder(
            animation: pageController,
            builder: (context, child) {
              // Get current scroll position (e.g. 0.0 to 1.0)
              double pageOffset = 1.0;
              if (pageController.hasClients && pageController.position.haveDimensions) {
                pageOffset = pageController.page ?? provider.selectedTab.toDouble();
              } else {
                pageOffset = provider.selectedTab.toDouble();
              }

              // Clamp thumb position between 0 and tabWidth
              final currentThumbLeft = (pageOffset * tabWidth).clamp(0.0, tabWidth);
              final isCloserToTab0 = pageOffset < 0.5;

              return Stack(
                children: [
                  // White thumb that slides in 1:1 sync with the swipe
                  Positioned(
                    left: currentThumbLeft,
                    top: 0,
                    bottom: 0,
                    width: tabWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(pillRadius - padding),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tappable tab options
                  Row(
                    children: [
                      // Subscription
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => context.read<HomeScreenProvider>().setTab(0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Subscription',
                                    style: TextStyle(
                                      color: isCloserToTab0
                                          ? Colors.black
                                          : Colors.white70,
                                      fontSize: isTablet ? 15.0 : 13.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 8 : 6,
                                    vertical: isTablet ? 2 : 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCloserToTab0
                                        ? const Color(0xFFEEEEEE)
                                        : const Color(0xFF434960),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Daily',
                                    style: TextStyle(
                                      color: isCloserToTab0
                                          ? Colors.black87
                                          : Colors.white60,
                                      fontSize: isTablet ? 10.0 : 9.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // One-Time Service
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => context.read<HomeScreenProvider>().setTab(1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'One-Time Service',
                                    style: TextStyle(
                                      color: !isCloserToTab0
                                          ? Colors.black
                                          : Colors.white70,
                                      fontSize: isTablet ? 15.0 : 13.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 8 : 6,
                                    vertical: isTablet ? 2 : 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !isCloserToTab0
                                        ? const Color(0xFFEEEEEE)
                                        : const Color(0xFF434960),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Quick Booking',
                                    style: TextStyle(
                                      color: !isCloserToTab0
                                          ? Colors.black87
                                          : Colors.white60,
                                      fontSize: isTablet ? 10.0 : 9.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}