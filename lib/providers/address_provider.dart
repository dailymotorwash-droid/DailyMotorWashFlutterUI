import 'package:dmw/models/address.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {

  List<Address> _addresses = [];

  List<Address> get addresses => _addresses;

  Address? _selectedAddress;

  Address? get selectedAddress => _selectedAddress;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  // Set vehicles from API
  void setAddresses(List<Address> addresses) {
    _addresses = addresses;
    notifyListeners();
  }

  // Add new vehicle
  void addAddresses(Address addresses) {
    _addresses.add(addresses);
    notifyListeners();
  }

  // Select vehicle
  void selectAddress(Address address) {
    _selectedAddress = address;
    notifyListeners();
  }

  // Remove vehicle
  void removeVehicle(String vehicleId) {
    _addresses.removeWhere((v) => v.id == vehicleId);
    notifyListeners();
  }
  void updateVehicle(Address updatedAddress) {

    int index = addresses.indexWhere((v) => v.id == updatedAddress.id);

    if (index != -1) {
      addresses[index] = updatedAddress;
      notifyListeners();
    }
  }
  // Clear vehicles on logout
  void clearVehicles() {
    _addresses.clear();
    _selectedAddress = null;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }
}