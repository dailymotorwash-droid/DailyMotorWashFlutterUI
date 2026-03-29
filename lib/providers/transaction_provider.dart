import 'package:dmw/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {

  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  Transaction? _selectedTransaction;

  Transaction? get selectedTransaction => _selectedTransaction;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  // Set vehicles from API
  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  // Add new vehicle
  void addVehicle(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  // Select vehicle
  void selectVehicle(Transaction transaction) {
    _selectedTransaction = transaction;
    notifyListeners();
  }

  // Remove vehicle
  void removeVehicle(String vehicleId) {
    _transactions.removeWhere((v) => v.id == vehicleId);
    notifyListeners();
  }

  // Clear vehicles on logout
  void clearVehicles() {
    _transactions.clear();
    _selectedTransaction = null;
    notifyListeners();
  }
  void updateTransaction(Transaction transaction) {

    int index = transactions.indexWhere((v) => v.id == transaction.id);

    if (index != -1) {
      transactions[index] = transaction;
      notifyListeners();
    }
  }
  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }
}