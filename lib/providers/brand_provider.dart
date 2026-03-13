import 'package:car_wash/models/brand.dart';
import 'package:flutter/cupertino.dart';

class BrandProvider extends ChangeNotifier{

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Brand> _brands = [];

  List<Brand> get brands => _brands;


  void setBrands(List<Brand> brands) {
    _brands = brands;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }
}