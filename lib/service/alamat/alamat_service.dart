import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlamatService {
  final Dio _dio = Dio();

  // Endpoint base url
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  // Mendapatkan token dari 'SharedPreferences'
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Method yang digunakan untuk mengambil data alamat
  Future<List<Map<String, dynamic>>> getAlamatToko() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu.');
    }

    try {
      // Lakukan GET Request ke endpoint backend
      final response = await _dio.get(
        '$_baseUrl/alamat-toko',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          }
        )  
      );

      // Periksa apakah request berhasil
      if (response.statusCode == 200) {
        // Ambil data dari response
        final List<dynamic> data = response.data['data'];
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Gagal mengambil data alamat');
      }
    } on DioException catch (e) {
      // Tangani error dari Dio
      throw Exception('Gagal mengambil data alamat: ${e.message}');
    }
  }

  // Method yang digunakan untuk menambahkan data alamat
  Future<void> addAlamatToko(Map<String, dynamic> data) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception(
        'Token tidak ditemukan. Anda harus login terlebih dahulu.'
      );
    }

    // Cetak data yang akan dikirim

    try {
      final response = await _dio.post(
        '$_baseUrl/alamat-toko',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal menambahkan alamat');
      }
    } on DioException catch(e) {
      throw Exception('Gagal menambahkan alamat: ${e.message}');
    }
  }

  // Method yang digunakan untuk menghapus alamat
  Future<void> deleteAlamatToko(int id) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception(
        'Token tidak ditemukan. Anda harus login terlebih dahulu.'
      );
    }

    try {
      final response = await _dio.delete(
        '$_baseUrl/alamat-toko/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal menghapus alamat');
      }
    } on DioException catch(e) {
      throw Exception('Gagal menghapus alamat: ${e.message}');
    }
  }

  // Method yang digunakan untuk mengatur alamat menjadi alamat utama
  Future<void> setAlamatUtama(int id) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception(
        'Token tidak ditemukan. Anda harus login terlebih dahulu.'
      );
    }

    try {
      final response = await _dio.put(
        '$_baseUrl/alamat-toko/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal mengatur alamat menjadi utama');
      }
    } on DioException catch(e) {
      throw Exception('Gagal mengatur alamat menjadi utama: ${e.message}');
    }
  }
}