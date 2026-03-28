import 'package:car_wash/providers/user_provider.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/utils/deep_link_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:car_wash/utils/page_routes.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ super.key });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final Logger logger = Logger();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final DeepLinkService _deepLinkService = DeepLinkService();

  late UserProvider userProvider;

  @override
  void initState() {
    logger.i("Splash Screen Loaded");
    // ✅ Context available AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deepLinkService.initDeepLinks(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    userProvider = Provider.of<UserProvider>(context);
    _navigateFurther(context: context);
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex:1 ,child: Image.asset('assets/images/logo.png',height: 100, width: 100)),
            // const SizedBox(width: 12),
            const Expanded(flex:2,
              child: Text(
                'Daily Motor Wash',
                style: AppTextStyles.whiteFont24Bold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                // textAlign: TextAlign.center,
              ),
            ),
          ]
        )
      ),
    );
  }

  void _navigateFurther({required BuildContext context}){
    String? state = userProvider.user?.state;
    logger.d(state);

    // state = 'registered_user';

    Future.delayed(const Duration(seconds: 2), () async {

      var storage = await LocalStorage.getInstance();
      if (storage.getToken() != null && storage.getToken()!.isNotEmpty) {
        if (kDebugMode) {
          print("token at intial start :- ${storage.getToken()!.isEmpty}");
        }
        state = 'registered_user';
      }
      switch (state) {
        case 'verified_lead':
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.profileScreen, (Route<dynamic> route) => false);

        case 'registered_user':
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.homeScreen, (Route<dynamic> route) => false);

        default:
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.loginScreen, (Route<dynamic> route) => false);
      }
    });
  }
}