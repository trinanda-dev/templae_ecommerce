// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shop_app/service/raja_ongkir_service.dart/raja_ongkir_service.dart';

class RajaOngkirProvider with ChangeNotifier {
  final RajaOngkirService _rajaOngkirService = RajaOngkirService();

  List<Map<String, dynamic>> _provinces = [];
  List<Map<String, dynamic>> _cities = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get provinces => _provinces;
  List<Map<String, dynamic>> get cities => _cities;
  bool get isLoading => _isLoading;

  // Mendapatkan daftar provinsi
  Future<void> fetchProvinces() async {
    if (_provinces.isNotEmpty) {
      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      _provinces = await _rajaOngkirService.getProvinces();
    } catch (e) {
      print("Error fetching provinces: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mendapatkan daftar kota berdasarkan provinsi
  Future<void> fetchCities(String provinceId) async {
    if (_cities.isNotEmpty) {
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    try {
      _cities = await _rajaOngkirService.getCities(provinceId);
    } catch (e) {
      print("Error fetching cities: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCities() {
    _cities = [];
    notifyListeners();
  }
}