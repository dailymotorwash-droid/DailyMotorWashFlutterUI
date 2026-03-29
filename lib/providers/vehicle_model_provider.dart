import 'package:dmw/models/model.dart';
import 'package:flutter/cupertino.dart';

class VehicleModelProvider extends ChangeNotifier{


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Model? _selectedModel;
  Model? get selectedModel => _selectedModel;
  List<Model> _models = [];

  List<Model> get models => _models;


  void setModels(List<Model> models) {
    _models = models;
    notifyListeners();
  }

  void setSelectedModel(Model model){
    _selectedModel = model;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }
}