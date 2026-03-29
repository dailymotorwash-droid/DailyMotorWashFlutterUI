import 'package:dmw/models/brand.dart';
import 'package:flutter/cupertino.dart';

class BrandProvider extends ChangeNotifier{

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Brand? _selectedBrand;
  Brand? get selectedBrand => _selectedBrand;
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

  void setSelectedBrand(Brand brand) {
    _selectedBrand = brand;
    notifyListeners();
  }
}