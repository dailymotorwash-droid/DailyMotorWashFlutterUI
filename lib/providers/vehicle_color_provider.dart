import 'package:dmw/models/model.dart';
import 'package:dmw/models/vehicle_color.dart';
import 'package:flutter/cupertino.dart';

class VehicleColorProvider extends ChangeNotifier{


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  VehicleColor? _selectedColor;
  VehicleColor? get selectedColor => _selectedColor;

  List<VehicleColor> _colors = [];

  List<VehicleColor> get colors => _colors;


  void setColors(List<VehicleColor> colors) {
    _colors= colors;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  void setSelectedColor(VehicleColor color) {
    _selectedColor = color;
    notifyListeners();
  }
  void clear(){
    _selectedColor =null;
    _isLoading = false;
    _colors = [];
    notifyListeners();
  }
}