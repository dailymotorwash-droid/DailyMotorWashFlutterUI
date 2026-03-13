import 'package:flutter/material.dart';
import 'package:car_wash/models/vehicle.dart';

class VehicleProvider extends ChangeNotifier {

  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  Vehicle? _selectedVehicle;

  Vehicle? get selectedVehicle => _selectedVehicle;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  // Set vehicles from API
  void setVehicles(List<Vehicle> vehicles) {
    _vehicles = vehicles;
    notifyListeners();
  }

  // Add new vehicle
  void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  // Select vehicle
  void selectVehicle(Vehicle vehicle) {
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