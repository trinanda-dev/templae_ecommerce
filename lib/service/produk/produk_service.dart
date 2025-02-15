import 'dart:convert';
import 'package:http/http.dart' as http;

class ProdukService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/produk'),
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
}