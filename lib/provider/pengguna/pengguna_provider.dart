import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop_app/service/pengguna/pengguna_service.dart';

class PenggunaProvider extends ChangeNotifier{
  final PenggunaService _penggunaService = PenggunaService();

  Map<String, dynamic>? _pengguna;
  bool _isLoading = false;
  String _errorMessage = '';
  
  // Getter untuk pengguna
  Map<String, dynamic>? get pengguna => _pengguna;

  // Getter untuk is loading
  bool get isLoading => _isLoading;

  // Getter untuk error message
  String get errorMessage => _errorMessage;

  // Method yang digunakan untuk mengambil data pengguna dari sercice
  Future<void> fetchPengguna() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Ambil data dari service
      _pengguna = await _penggunaService.getPengguna();
      _errorMessage = ''; // Reset pesan error jika berhasil
    } catch (e) {
      // Tangani error
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method yang digunakan untuk mengupdate data pengguna ke service
  Future<void> update(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _penggunaService.updateDataPengguna(data);
      _errorMessage = ''; // Reset pesan error jika berhasil
    } catch (e) {
      // Tangani error
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method yang digunakan untuk mengupdate data pengguna dengan gambar ke service
  Future<void> updateWithImage(Map<String, dynamic> data, File imageFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _penggunaService.updateDataPenggunaWithImage(data, imageFile);
      fetchPengguna(); // Refresh data setelah update
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}