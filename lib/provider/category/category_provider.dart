import 'package:flutter/material.dart';
import 'package:shop_app/service/category/category_service.dart';

class CategoryProvider extends ChangeNotifier{
  final CategoryService _kategoriService = CategoryService();
  List <Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;

  // Fungsi yang digunakan untuk menampilkan kategori di halaman home berdasarkan ketgori yang ada pada database
  Future<void> fetchCategories() async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await _kategoriService.getCategories();
      _categories = List<Map<String, dynamic>>.from(data);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Terjadi kesalahan saat memuat kategori');
    }
  }
}