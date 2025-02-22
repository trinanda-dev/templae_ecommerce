import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CartService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  // Mendapatkan token dari 'SharedPreferences'
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Melakukan penambahan item di keranjang pengguna
  Future<Map<String, dynamic>> addToCart(int productId, {
   int? variantId, int jumlah = 1}) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu.');
    }

    final url = Uri.parse('$baseUrl/keranjang/add');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = json.encode({
      'produk_id': productId,
      'variant_id': variantId,
      'jumlah': jumlah,
      });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Gagal menambahkan ke keranjang',
        };
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menambahkan ke keranjang: $e');
    }
  }

  // Mendapatkan daftar item di dalam cart pengguna
  Future<Map<String, dynamic>> getCartItem({List<int>? selectedItemIds}) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu');
    }

    Uri uri = Uri.parse('$baseUrl/detail-keranjang');
    if (selectedItemIds != null && selectedItemIds.isNotEmpty) {
      uri = uri.replace(queryParameters: {
        'item_ids': selectedItemIds.map((id) => id.toString()).toList(),
      });
    }

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'success': true,
        'data': data['data'],
        'total': data['total'],
      };
    } else {
      throw Exception('Gagal mendapatkan daftar item di keranjang');
    }
  }

  // Menghapus produk dari cart
  Future<Map<String, dynamic>> removeFromCart(int cartItemId, int productId, {int? variantId}) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/keranjang/$cartItemId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'produk_id': productId,  // Mengirim produk_id untuk memastikan item yang benar dihapus
        'variant_id': variantId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final Map<String, dynamic> error = json.decode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Gagal menghapus dari keranjang',
      };
    }
  }

  // Fungsi untuk memperbarui item keranjang
  Future<Map<String, dynamic>> updateCartItem(int cartItemId, int jumlah, int produkId) async {
    final token = await _getToken(); // cartItemId menggantikan cartId
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu');
    }

    final url = Uri.parse('$baseUrl/keranjang/$cartItemId'); // Menggunakan cartItemId
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'jumlah': jumlah,
      'produk_id': produkId, // Menambahkan produk_id
    });

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Gagal memperbaharui item di keranjang',
        };
      }
    } catch (e) {
      throw Exception('Gagal memperbaharui item di keranjang: $e');
    }
  }

  // Fungsi yang digunakan untuk memanggil jumlah produk
  Future<int> getProductStock(int productId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception(
        'Token tidak ditemukan. Anda harus login terlebih dahulu'
      );
    }

    final url = Uri.parse(
      '$baseUrl/products/$productId/stock',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      }
    );

    if (response.statusCode == 200) {
      final data = json.decode(
        response.body
      );
      return data['data'];
    } else {
      throw Exception(
        'Gagal mendapatkan stock produk'
      );
    }
  }

  // Mendapatkan daftar item di dalam cart pengguna
  Future<Map<String, dynamic>> getQuantityCartItem() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu');
    }

    Uri uri = Uri.parse('$baseUrl/keranjang');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'success': true,
        'data': data['data'],
      };
    } else {
      throw Exception('Gagal mendapatkan daftar item di keranjang');
    }
  }

  // Method yang digunakan untuk melakukan checkout terhadap produk
  Future<Map<String, dynamic>> checkout() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu.');
    }

    final url = Uri.parse('$baseUrl/checkout');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(url, headers: headers);
      
      // Debugging untuk melihat isi response
      debugPrint("Checkout API Response: ${response.body}");
      
      final result = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return result;
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Terjadi kesalahan saat checkout.',
        };
      }
    } catch (e) {
      throw Exception('Gagal melakukan checkout: $e');
    }
  }
}