import 'package:flutter/material.dart';
import 'package:shop_app/service/alamat/alamat_service.dart';

class AlamatProvider with ChangeNotifier{
  final AlamatService _alamatService = AlamatService();
  
  List<Map<String, dynamic>> _alamatTokoList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getter untuk daftar alamat toko
  List<Map<String, dynamic>> get alamatTokoList => _alamatTokoList;

  // Getter untuk status loading
  bool get isLoading => _isLoading;

  // Getter untuk pesan error
  String get errorMessage => _errorMessage;

  // Method untuk mengambil data alamat toko dari service
  Future<void> fetchAlamatToko() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Ambil data dari service
      _alamatTokoList = await _alamatService.getAlamatToko();
      _errorMessage = ''; // Reset pesan error jika berhasil
    } catch (e) {
      // Tangani error
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method yang digunkan untuk menambahkan data alamat ke service
  Future<void> addAlamatToko(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    // Cetak data uang dikirim ke service

    try {
      await _alamatService.addAlamatToko(data);
      _errorMessage = ''; // Reset pesan error jika berhasil
      // Refresh data setelah menambahkan alamat baru
      await fetchAlamatToko();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method yang digunakan untuk menghapus data alamat
  Future<void> deleteAlamatToko(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _alamatService.deleteAlamatToko(id);
      _errorMessage = '';
      // Refresh data setelah menghapus alamat
      await fetchAlamatToko();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method yang digunakan untuk mengatur alamat menjadi alamat utama
  Future<void> setUtamaAlamatToko(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _alamatService.setAlamatUtama(id);
      _errorMessage = '';
      // Refresh data setelah mengatur alamat menjadi utama
      await fetchAlamatToko();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}