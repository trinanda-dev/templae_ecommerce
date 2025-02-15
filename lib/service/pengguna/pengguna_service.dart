import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PenggunaService {
  // Dio untuk berkomunikasi
  final Dio _dio = Dio();

  // Endpoint base url
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  // Mendapatkan token dari 'SharedPreferences'
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Method yang digunakan untuk mengambil data pengguna
  Future<Map<String, dynamic>> getPengguna() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu.');
    }

    try {
      // Lakukan Get Request ke endpoint backend
      final response = await _dio.get(
        '$_baseUrl/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );

      // Periksa apakah request berhasil
      if (response.statusCode == 200) {
        // Ambil data dari response)
        print("Data Pengguna: ${response.data['data']}");
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception('Gagal mengambil data pengguna');
      }
    } on DioException catch (e) {
      // Tangani error dari Dio
      throw Exception('Gagal mengambil data pengguna: ${e.message}');
    }
  }

  // Method yang digunakan untuk mengupdate data pengguna
  Future<void> updateDataPengguna(Map<String, dynamic> data) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception(
        'Token tidak ditemukan. Anda harus login terlebih dahulu.'
      );
    }

    try {
      final response = await _dio.put(
        '$_baseUrl/profile',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal mengupdate data pengguna');
      }
    } on DioException catch(e) {
      throw Exception('Gagal mengupdate data pengguna: ${e.message}');
    }
  }

  // Method yang digunakan untuk mengupdate data pengguna dengan gambar
    Future<void> updateDataPenggunaWithImage(Map<String, dynamic> data, File imageFile) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu.');
    }

    try {
      FormData formData = FormData.fromMap({
        ...data,
        'image': await MultipartFile.fromFile(imageFile.path, filename: 'profile.jpg'),
      });

      final response = await _dio.put(
        '$_baseUrl/pengguna',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal mengupdate data pengguna dengan gambar');
      }
    } on DioException catch (e) {
      throw Exception('Gagal mengupdate data pengguna dengan gambar: ${e.message}');
    }
  }
}