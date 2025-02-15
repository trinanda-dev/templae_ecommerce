import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/service/brands/brand_service.dart';

class BrandProvider extends ChangeNotifier {
  final BrandService _brandService = BrandService();
  List<Map<String, dynamic>> _brands = [];
  List<Product> _productBrands = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get brands => _brands;
  List<Product> get productBrands => _productBrands;
  bool get isLoading => _isLoading;


  // Fungsi yang digunakan untuk menampilkan brand di halaman home berdasarkan brand brand yang ada pada produk
  Future<void> fetchBrands() async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await _brandService.getBrands();
      _brands = List<Map<String, dynamic>>.from(data);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Terjadi kesalahan saat memuat kategori');
    }
  }

  // Fungsi yang digunakan untuk menampilkan product di halaman brand page jadi produk yang ditampilkan di filter berdasarkan brand yang dipilih oleh pengguna
  Future<void> fetchProductsByBrand(int brandId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await _brandService.getProductsByBrand(brandId);
      _productBrands = data.map<Product>((json) => Product.fromJson(json)).toList() ;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Terjadi kesalahan saat memuat produk berdasarkan brand');
    }
  }
}