import 'dart:convert';
import 'package:http/http.dart' as http;

class ProdukService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(
          response.body,
        );
        return data['data'];
      } else {
        throw Exception('Gagal Memuat Produk');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat produk');
    }
  }

  // Ambli varian produk berdasarkan productId
  Future<List<dynamic>> getVariants(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId/variants'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Pastikan 'data' ada dan dalam bentuk list
        if (data['success'] == true && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('Data varian tidak ditemukan');
        }
      } else {
        throw Exception('Gagal memuat varian');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat varian: $e');
    }
  }
}