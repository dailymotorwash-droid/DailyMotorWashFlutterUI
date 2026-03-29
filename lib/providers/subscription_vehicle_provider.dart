import 'package:dmw/models/subscription_vehicle.dart';
import 'package:flutter/material.dart';

class SubscriptionVehicleProvider extends ChangeNotifier {

  List<SubscriptionVehicle> _vehicles = [];

  List<SubscriptionVehicle> get vehicles => _vehicles;

  SubscriptionVehicle? _selectedVehicle;

  SubscriptionVehicle? get selectedVehicle => _selectedVehicle;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  // Set vehicles from API
  void setVehicles(List<SubscriptionVehicle> vehicles) {
    _vehicles = vehicles;
    notifyListeners();
  }

  // Add new vehicle
  void addVehicle(SubscriptionVehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  // Select vehicle
  void selectVehicle(SubscriptionVehicle vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  // Remove vehicle
  void removeVehicle(String vehicleId) {
    _vehicles.removeWhere((v) => v.id == vehicleId);
    notifyListeners();
  }

  // Clear vehicles on logout
  void clearVehicles() {
    _vehicles.clear();
    _selectedVehicle = null;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }
}