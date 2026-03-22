import 'package:car_wash/models/plan.dart';
import 'package:flutter/material.dart';

class ServiceProvider extends ChangeNotifier {

  List<Plan> _planes = [];
  bool _isLoading = false;
  List<Plan> get planes => _planes;
  bool get isLoading => _isLoading;
  Plan? _selectedPlan;

  Plan? get selectedPlan => _selectedPlan;

  // Set vehicles from API
  void setPlans(List<Plan> planes) {
    _planes = planes;
    notifyListeners();
  }

  // Add new vehicle
  void addPlan(Plan planes) {
    _planes.add(planes);
    notifyListeners();
  }

  // Select vehicle
  void selectPlan(Plan vehicle) {
    _selectedPlan = vehicle;
    notifyListeners();
  }

  // Remove vehicle
  void removePlan(int planId) {
    _planes.removeWhere((v) => v.id == planId);
    notifyListeners();
  }

  // Clear vehicles on logout
  void clearPlans() {
    _planes.clear();
    _selectedPlan = null;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }



}