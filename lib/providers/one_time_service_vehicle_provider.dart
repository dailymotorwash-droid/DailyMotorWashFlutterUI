import 'package:dmw/models/subscription_vehicle.dart';
import 'package:flutter/material.dart';

import '../models/one_time_booking_vehicle.dart';

class OneTimeServiceVehicleProvider extends ChangeNotifier {

  List<OneTimeBookingVehicle> _vehicles = [];

  List<OneTimeBookingVehicle> get vehicles => _vehicles;

  OneTimeBookingVehicle? _selectedVehicle;

  OneTimeBookingVehicle? get selectedVehicle => _selectedVehicle;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  // Set vehicles from API
  void setVehicles(List<OneTimeBookingVehicle> vehicles) {
    _vehicles = vehicles;
    notifyListeners();
  }

  // Add new vehicle
  void addVehicle(OneTimeBookingVehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  // Select vehicle
  void selectVehicle(OneTimeBookingVehicle vehicle) {
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

  bool isVehiclePresent(String vehicleId) {
    return _vehicles.any((vehicle) => vehicle.vehicleId == vehicleId);
  }
}