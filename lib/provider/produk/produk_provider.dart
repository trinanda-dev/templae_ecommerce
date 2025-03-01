import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/service/produk/produk_service.dart';

class ProdukProvider extends ChangeNotifier {
  final ProdukService _produkService = ProdukService();
  List<Product> _products = [];
  bool _isLoading = false;
  String _searchQuery = ""; // 🔍 Menyimpan query pencarian

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> fetchProducts({String search = ""}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await _produkService.getProducts(search: search);
      _products = data.map<Product>((json) => Product.fromJson(json)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Terjadi kesalahan saat memuat produk: $e');
    }
  }

  // 🔥 Real-time Search
  void searchProducts(String query) {
    _searchQuery = query;
    fetchProducts(search: query); // 🔄 Langsung panggil API dengan query baru
  }
}