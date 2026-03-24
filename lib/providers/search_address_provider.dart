import 'package:car_wash/models/master_address.dart';
import 'package:flutter/cupertino.dart';

class SearchAddressProvider extends ChangeNotifier {

  List<MasterAddress> _suggestions = [];
  MasterAddress? _selectedAddress ;
  List<MasterAddress> get suggestions => _suggestions;
  MasterAddress? get selectedAddress => _selectedAddress;
  bool _showDropdown = false;
  bool get showDropdown => _showDropdown;
  void setAddress(List<MasterAddress> addresses){
    _suggestions = addresses;
    notifyListeners();
  }

  void isDropDownEnable(bool isDropdownEnable ){
    _showDropdown = isDropdownEnable;
    notifyListeners();
  }
  void setSelectedAddress(MasterAddress selectedAddress){
    _selectedAddress = selectedAddress;
    notifyListeners();
  }

  void clearSelectedAddress() {
    _selectedAddress = null;
    _suggestions =[];
    _showDropdown = false;
    notifyListeners();
  }

  Future<void> search(String query) async {

    if (query.isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }

    /// Example API call
    /// final response = await Api.searchAddress(query);

    List<String> data = [
      "Indirapuram",
      "Noida Sector 62",
      "Ghaziabad",
      "Vaishali",
      "Kaushambi"
    ];

    // _suggestions = data
    //     .where((e) => e.toLowerCase().contains(query.toLowerCase()))
    //     .toList();

    notifyListeners();
  }
}