import 'dart:convert';
import 'package:http/http.dart' as http;

class BrandService {
  final String baseUrl = 'http://10.0.2.2:8000/api'; // Endpoint utama
  
  // Fungsi yang digunakan untuk menampilkan brand-brand yang dimiliki oleh produk
  Future<List<dynamic>> getBrands() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/brands'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['data']; // Return daftar brands
      } else {
        throw Exception('Gagal Memuat Kategori');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat kategori');
    }
  }

  // Fungsi yang digunakan untuk menampilkan produk-produk berdasarkan brand
  Future<List<dynamic>> getProductsByBrand(int brandId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/products/brand/$brandId',
        )
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception(
          'Gagal memuat produk berdasarkan brand'
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat produk berdasarkan brand');
    }
  }
}