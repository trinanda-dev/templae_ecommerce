import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop_app/service/pesanan/pesanan_service.dart';

class PesananProvider extends ChangeNotifier {
  final PesananService _pesananService = PesananService();
  Map<String, dynamic>? _pesanan;
  bool _isLoading = false;
  bool _hasUpdated = false; // Cek apakah status pesanan berubah
  String? _errorMessage; // Menyimpan pesan error jika ada
  bool _isUploading = false;
  String? _buktiTransferUrl;
  List<Map<String, dynamic>> _pesananList = [];

  List<Map<String, dynamic>> get pesananList => _pesananList;
  Map<String, dynamic>? get pesanan => _pesanan;
  bool get isLoading => _isLoading;
  bool get hasUpdated => _hasUpdated;
  String? get errorMessage => _errorMessage;
  bool get isUploading => _isUploading;
  String? get buktiTransferUrl => _buktiTransferUrl;


  Future<void> fetchPesanan(int pesananId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _pesananService.fetchPesanan(pesananId);
      debugPrint("Fetching pesanan...");

      if (result['success']) {
        final newPesanan = result['data'];

        // Cek apakah status berubah menjadi "Menunggu Pembayaran"
        if (_pesanan != null &&
            _pesanan!['status'] == "Menunggu Validasi Admin" &&
            newPesanan['status'] == "Menunggu Pembayaran") {
          _hasUpdated = true; 
        }

        // Perbarui data pesanan hanya jika ada perubahan
        if (_pesanan == null || _pesanan!['status'] != newPesanan['status'] || 
            _pesanan!['ongkos_kirim'] != newPesanan['ongkos_kirim']) {
          _pesanan = newPesanan;
        }

        notifyListeners();
      } else {
        _errorMessage = result['message']; 
        _pesanan = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Gagal mengambil pesanan: $e";
      _pesanan = null;
      notifyListeners();
    } finally {
      _isLoading = false;
    }
  }

  // Method yang digunakan untuk mengunggah bukti transfer
  Future<void> uploadBuktiTransfer(int pesananId, File buktiTransfer) async {
    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _pesananService.uploadBuktiTransfer(pesananId, buktiTransfer);

      if (result['success']) {
        _buktiTransferUrl = result['data']['bukti_transfer_url'];
        debugPrint("Bukti transfer berhasil diunggah: $_buktiTransferUrl");
        notifyListeners();
      } else {
        _errorMessage = result['message'];
        debugPrint("Gagal mengunggah bukti transfer: $_errorMessage");
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Gagal mengunggah bukti transfer: $e';
      debugPrint(_errorMessage);
      notifyListeners();
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  // Method yang digunakan untuk mengambil seluruh pesanan
  Future<void> fetchAllPesanan() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _pesananService.fetchAllPesanan();

      if (result['success']) {
        _pesananList = List<Map<String, dynamic>>.from(result['data']);
        notifyListeners();
      } else {
        _errorMessage = result['message'];
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Gagal mengambil pesanan: $e";
      notifyListeners();
    } finally {
      _isLoading = false;
    }
  }
}