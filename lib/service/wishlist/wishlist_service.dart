import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WishlistService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  /// Mendapatkan token dari `SharedPreferences`
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Mendapatkan daftar wishlist pengguna
  Future<List<dynamic>> getWishlist() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/wishlist'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal memuat wishlist');
    }
  }

  /// Menambahkan produk ke wishlist
  Future<Map<String, dynamic>> addToWishlist(int productId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/wishlist'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'produk_id': productId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final Map<String, dynamic> error = json.decode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Gagal menambahkan ke wishlist',
      };
    }
  }

  /// Menghapus produk dari wishlist
  Future<Map<String, dynamic>> removeFromWishlist(int productId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu.');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/wishlist/$productId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'produk_id': productId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final Map<String, dynamic> error = json.decode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Gagal menghapus dari wishlist',
      };
    }
  }
}