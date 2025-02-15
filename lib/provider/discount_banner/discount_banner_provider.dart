import 'package:flutter/material.dart';
import 'package:shop_app/service/discount_banner/discount_banner_service.dart';

class DiscountBannerProvider extends ChangeNotifier{
  final DiscountBannerService _discountBannerService = DiscountBannerService();
  List<Map<String, dynamic>> _discountBanners = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get discountBanner => _discountBanners;
  bool get isLoading => _isLoading;

  Future<void> fetchDiscountBanner({bool forceReload = false}) async {
    // Jika data sudah ada dan tidak dipaksa reload, langsung return
    if (_discountBanners.isNotEmpty && !forceReload) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _discountBannerService.getDiscountBanners();
      _discountBanners = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint("Gagal mengambil kategori: $e");
      _discountBanners = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}