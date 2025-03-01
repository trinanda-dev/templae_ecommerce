import 'dart:convert';
import 'package:flutter/foundation.dart'; // Diperlukan untuk debugPrint
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final http.Client client;

  ResetPasswordService({required this.client});

  /// **1️⃣ Kirim Token Reset Password ke Email**
  Future<void> sendResetToken(String email) async {
    debugPrint("🔹 Mengirim token reset password ke: $email");

    final response = await client.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    debugPrint("📩 Response Status: ${response.statusCode}");
    debugPrint("📩 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('reset_email', email);
      debugPrint("✅ Email disimpan di SharedPreferences: $email");
    } else {
      final result = jsonDecode(response.body);
      debugPrint("❌ Gagal mengirim reset password: ${result['message']}");
      throw Exception(result['message']);
    }
  }

  /// **2️⃣ Verifikasi Token Reset Password**
  Future<void> verifyResetCode(String email, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('reset_email');
    
    debugPrint("🔹 Memverifikasi token untuk email: $storedEmail dengan token: $token");

    final response = await client.post(
      Uri.parse('$baseUrl/verify-reset-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': storedEmail,
        'token': token
      }),
    );

    debugPrint("🔑 Response Status: ${response.statusCode}");
    debugPrint("🔑 Response Body: ${response.body}");

    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await prefs.setString('reset_token', token);
      debugPrint("✅ Token disimpan di SharedPreferences: $token");
    } else {
      debugPrint("❌ Token tidak valid: ${result['message']}");
      throw Exception(result['message']);
    }
  }

  /// **3️⃣ Reset Password**
  Future<void> resetPassword(String password, String passwordConfirm) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('reset_email');
    final token = prefs.getString('reset_token');

    if (email == null || token == null) {
      debugPrint("❌ Session expired, tidak ada email atau token di SharedPreferences");
      throw Exception("Session expired. Please request a new reset code.");
    }

    debugPrint("🔹 Mengirim request reset password untuk email: $email");

    final response = await client.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirm,
      }),
    );

    debugPrint("🔐 Response Status: ${response.statusCode}");
    debugPrint("🔐 Response Body: ${response.body}");

    final result = jsonDecode(response.body);
    if (response.statusCode != 200) {
      debugPrint("❌ Reset password gagal: ${result['message']}");
      throw Exception(result['message']);
    }

    // **Hapus session token setelah berhasil reset password**
    await prefs.remove('reset_email');
    await prefs.remove('reset_token');
    debugPrint("✅ Reset password berhasil, email & token dihapus dari SharedPreferences");
  }
}