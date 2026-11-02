import 'package:dmw/models/user.dart';
import 'package:dmw/providers/user_provider.dart';
import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:dmw/utils/deep_link_service.dart';
import 'package:flutter/material.dart';

import 'package:dmw/utils/page_routes.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../utils/AuthHandler.dart';
import '../utils/local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ super.key });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final Logger logger = Logger();
  final DeepLinkService _deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();
    logger.i("Splash Screen Loaded");

    // Global logout callback
    AuthHandler.onLogout = () {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.loginScreen,
          (route) => false,
        );
      }
    };

    // Run navigation after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deepLinkService.initDeepLinks(context);
      _navigateFurther();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Image.asset('assets/images/logo.png', height: 100, width: 100)),
            const Expanded(
              flex: 2,
              child: Text(
                'Daily Motor Wash',
                style: AppTextStyles.whiteFont24Bold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateFurther() async {
    // Smooth splash experience (1.2 seconds)
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final storage = await LocalStorage.getInstance();
    if (!mounted) return;

    final String? token = storage.getToken();
    final String? status = storage.getStatus();

    // If a saved backend auth token exists, user stays logged in
    if (token != null && token.isNotEmpty) {
      final String? firstName = LocalStorage.getFirstName();
      final String? lastName = storage.getLastName();
      final String? phone = storage.getPhone();
      final int? userId = storage.getUserId();

      // Restore user session in memory (UserProvider) on cold start
      context.read<UserProvider>().login(
        User(
          id: userId,
          firstName: firstName,
          lastName: lastName,
          phone: phone ?? '',
          token: token,
          status: status,
          state: status ?? 'registered_user',
        ),
      );

      if (status == 'verified_lead') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.profileScreen,
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeScreen,
          (route) => false,
        );
      }
    } else {
      // No saved token, navigate to Login
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginScreen,
        (route) => false,
      );
    }
  }
}
