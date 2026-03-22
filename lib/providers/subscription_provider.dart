import 'package:car_wash/models/subscription.dart';
import 'package:flutter/material.dart';

class SubscriptionProvider extends ChangeNotifier {

  List<Subscription> _subscriptions = [];

  List<Subscription> get subscriptions => _subscriptions;

  Subscription? _selectedSubscription;

  Subscription? get selectedSubscription => _selectedSubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DateTime? _selectedStartDate;
  DateTime? get selectedStartDate => _selectedStartDate;


  // Set vehicles from API
  void setSubscription(List<Subscription> subscriptions) {
    _subscriptions = subscriptions;
    notifyListeners();
  }

  // Add new vehicle
  void addVehicle(Subscription subscription) {
    _subscriptions.add(subscription);
    notifyListeners();
  }

  // Select vehicle
  void selectSubscription(Subscription subscription) {
    _selectedSubscription = subscription;
    notifyListeners();
  }

  // Remove vehicle
  void removeSubscription(String subscriptionId) {
    _subscriptions.removeWhere((v) => v.id == subscriptionId);
    notifyListeners();
  }

  // Clear vehicles on logout
  void clearSubscriptions() {
    _subscriptions.clear();
    _selectedSubscription = null;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  void setSelectedStartDate(DateTime date){
    _selectedStartDate = date;
    notifyListeners();
  }

  void clearStartDate(){
    _selectedStartDate = null;
    _selectedSubscription = null;
    notifyListeners();
  }
}