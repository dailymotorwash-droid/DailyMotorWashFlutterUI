import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermAndCondition extends StatefulWidget{
  const TermAndCondition({super.key});

  @override
  State<TermAndCondition> createState() => _TermAndConditionState();

}

class _TermAndConditionState extends State<TermAndCondition>{
  late final WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JS
      ..loadRequest(Uri.parse('https://www.dailymotorwash.com/terms-of-service.html'));
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Term & Condition ')),
      body: WebViewWidget(controller: controller), // Display the widget
    );
  }

}