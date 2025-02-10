import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = 'http://10.0.2.2:8000/api'; // Sesuaikan URL backend Anda

  // Fungsi yang digunakan untuk menampilkan kategori yang dimiliki dari produk
  Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/kategoris'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['data']; // Return daftar kategori
      } else {
        throw Exception('Gagal Memuat Kategori');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat kategori');
    }
  }
}