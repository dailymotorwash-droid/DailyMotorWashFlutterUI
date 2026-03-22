import 'package:app_links/app_links.dart';
import 'package:car_wash/views/login_screen.dart';
import 'package:flutter/material.dart';

class DeepLinkService{
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;

  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();

  Future<void> initDeepLinks(BuildContext context) async {
    // 🔹 App opened from terminated state
    final uri = await _appLinks.getInitialAppLink();

    if (uri != null) {
      handleLink(context, uri);
    }

    // 🔹 App already running
    _appLinks.uriLinkStream.listen((uri) {
      handleLink(context, uri);
        });
  }

  void handleLink(BuildContext context, Uri uri) {
    print("Deep link: $uri");

    // 👉 Check path
    if (uri.path == '/refer') {
      final code = uri.queryParameters['code'];

      if (code != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoginScreen(code: code),
          ),
        );
      }
    }

  }
}