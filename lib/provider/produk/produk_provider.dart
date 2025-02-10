import 'package:flutter/material.dart';
import 'package:shop_app/service/produk/produk_service.dart';

class ProdukProvider extends ChangeNotifier{
  final ProdukService _produkService = ProdukService();
  List <Map<String, dynamic>> _products = [];
  List <Map<String, dynamic>> _productVarians = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get productVarians => _productVarians;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await _produkService.getProducts();
      _products = List<Map<String, dynamic>>.from(data);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Terjadi kesalahan saat memuat produk: $e');
    }
  }

  // Fetch varians berdasarkan produk Id
  Future<void> fetchVariants(int productId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await _produkService.getVariants(productId);
      _productVarians = List<Map<String, dynamic>>.from(data);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Terjadi kesalahan saat memuat varian: $e');
    }
  }
}