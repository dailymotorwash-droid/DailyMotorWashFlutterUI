import 'package:flutter/material.dart';

import '../models/service.dart';



class OneTimeServiceProvider extends ChangeNotifier {

  List<Service> _services = [];

  List<Service> get services => _services;


  void setServices(List<Service> service){
    _services = service;
    notifyListeners();
  }
  void onBookService(BuildContext context, Service item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: ${item.serviceName}'),
        backgroundColor: const Color(0xFFE91E63),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}