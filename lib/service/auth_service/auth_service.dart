import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final http.Client client;

  AuthService({required this.client});

  // Method yang digunakan untuk melakukan sign up
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
    required String invitationCode,
    required String storeName,
    required String phoneNumber,
    required String address,
    required String cityId,
    required String city,
    required String provinceId,
    required String province,
    required String subDistrict,
    required String postalCode,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/sign-up'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirm,
        'kode_undangan': invitationCode,
        'nama_toko' : storeName,
        'nomor_hp': phoneNumber,
        'alamat_lengkap': address,
        'id_kota': cityId,
        'kota': city,
        'id_provinsi': provinceId,
        'provinsi': province,
        'kecamatan': subDistrict,
        'kode_pos': postalCode,
      })
    );

    return jsonDecode(response.body);
  }
  
  // Methode yang digunakan untuk melakukan login dan menyimpan token ke Shared Preferences
  Future<Map<String, dynamic>> login(String emailOrPhone, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email_or_phone': emailOrPhone,
        'password': password,
      },
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 && result['status'] == 'success') {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', result['token']); // Simpan token
      return result;
    }

    throw Exception(result['message'] ?? 'Login gagal.');
  }

  // Method yang digunakan untuk mendapatkan token dari Shared Prefenrences
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Method yang digunakan untuk melakukan logout
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      // Panggil API logout di backend
      final response = await client.post(
        Uri.parse('$baseUrl/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Hapus token dari SharedPrefenrences
        await prefs.remove('auth_token');
      } else {
        throw Exception('Logout gagal.');
      }
    }
  }
}