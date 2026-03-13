import 'package:car_wash/models/model.dart';
import 'package:flutter/cupertino.dart';

class VehicleModelProvider extends ChangeNotifier{


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Model> _models = [];

  List<Model> get models => _models;


  void setModels(List<Model> models) {
    _models = models;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }
}