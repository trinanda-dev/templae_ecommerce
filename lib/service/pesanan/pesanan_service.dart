import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PesananService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> fetchPesanan(int pesananId) async {
    final token = await _getToken();
    if (token == null) {
      return {
        'success': false,
        'message': 'Token tidak ditemukan. Anda harus login terlebih dahulu.',
      };
    }

    final url = Uri.parse('$baseUrl/pesanan/$pesananId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      final result = json.decode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        return result;
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Gagal mengambil data pesanan.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat mengambil pesanan: $e',
      };
    }
  }

  // Method yang digunakan untuk mengunggah bukti transfer
  Future<Map<String, dynamic>> uploadBuktiTransfer(int pesananId, File buktiTransfer) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu');
    }

    final url = Uri.parse('$baseUrl/pesanan/$pesananId/upload-bukti-transfer');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('bukti_transfer', buktiTransfer.path));

    debugPrint("Uploading file: ${buktiTransfer.path}");
    debugPrint("Request ke: $url");

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final result = json.decode(response.body);

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return result;
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Terjadi kesalahan saat mengunggah bukti transfer',
        };
      }
    } catch (e) {
      debugPrint("Error saat mengunggah: $e");
      throw Exception('Terjadi kesalahan saat mengunggah bukti transfer: $e');
    }
  }
}
