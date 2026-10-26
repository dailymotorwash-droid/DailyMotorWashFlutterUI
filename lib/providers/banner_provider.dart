import 'package:flutter/foundation.dart';

import '../../ApiResponse/banner_response.dart';
import '../../Apis/RestServiceImp.dart';
import '../../models/banner_model.dart';

class BannerProvider extends ChangeNotifier {
  List<BannerModel> _banners = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBanners() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final BannerResponse res = await RestServiceImp.getBanners();
      debugPrint('Banner API Success: ${res.isSuccess}');

      if (res.isSuccess && res.data != null) {
        _banners = res.data.where((b) => b.isActive).toList();
        debugPrint('Fetched ${_banners.length} active banners');
      } else {
        _errorMessage = res.message ?? 'Failed to load banners';
      }
    } catch (e, stack) {
      debugPrint('Error inside fetchBanners: $e');
      debugPrint('$stack');
      _errorMessage = e.toString();
    } finally {
      // THIS IS CRUCIAL: loader MUST stop regardless of success or failure
      _isLoading = false;
      notifyListeners();
    }
  }

  void setBanners(List<BannerModel> list) {
    _banners = list.where((b) => b.isActive).toList();
    _isLoading = false;
    notifyListeners();
  }
}