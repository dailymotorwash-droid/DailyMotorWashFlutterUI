import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final ValueNotifier<bool> isOffline = ValueNotifier(false);
  final ValueNotifier<bool> isBackOnline = ValueNotifier(false);

  StreamSubscription? _subscription;

  // 🔁 Queue for retry APIs
  final List<Function> _retryQueue = [];

  void startListening() {
    _subscription = Connectivity().onConnectivityChanged.listen((_) async {
      bool hasInternet = await _checkInternet();

      if (!hasInternet) {
        isOffline.value = true;
      } else {
        if (isOffline.value == true) {
          // came back online
          isBackOnline.value = true;
          _runRetryQueue();

          Future.delayed(const Duration(seconds: 2), () {
            isBackOnline.value = false;
          });
        }
        isOffline.value = false;
      }
    });
  }

  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // 🔁 Add API to retry queue
  void addToRetryQueue(Function apiCall) {
    _retryQueue.add(apiCall);
  }

  void _runRetryQueue() {
    for (var api in _retryQueue) {
      api();
    }
    _retryQueue.clear();
  }

  void dispose() {
    _subscription?.cancel();
  }
}