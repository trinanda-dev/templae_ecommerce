import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Diperlukan untuk debugPrint
import 'package:http/http.dart' as http;
import 'package:shop_app/service/reset_password/reset_password_service.dart';

class ResetPasswordProvider with ChangeNotifier {
  final ResetPasswordService _resetPasswordService = ResetPasswordService(client: http.Client());

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// **1️⃣ Kirim Reset Code**
  Future<void> sendResetCode(String email) async {
    _isLoading = true;
    notifyListeners();
    debugPrint("📩 Mengirim permintaan reset password untuk email: $email");

    try {
      await _resetPasswordService.sendResetToken(email);
      debugPrint("✅ Permintaan reset password berhasil dikirim untuk: $email");
    } catch (e) {
      debugPrint("❌ Gagal mengirim reset password: $e");
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// **2️⃣ Verifikasi Reset Token**
  Future<void> verifyResetCode(String email, String token) async {
    _isLoading = true;
    notifyListeners();
    debugPrint("🔑 Memverifikasi reset token untuk email: $email dengan token: $token");

    try {
      await _resetPasswordService.verifyResetCode(email, token);
      debugPrint("✅ Token berhasil diverifikasi untuk email: $email");
    } catch (e) {
      debugPrint("❌ Token verifikasi gagal: $e");
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// **3️⃣ Reset Password**
  Future<void> resetPassword(String password, String passwordConfirm) async {
    _isLoading = true;
    notifyListeners();
    debugPrint("🔐 Memulai proses reset password...");

    try {
      await _resetPasswordService.resetPassword(password, passwordConfirm);
      debugPrint("✅ Password berhasil diperbarui!");
    } catch (e) {
      debugPrint("❌ Reset password gagal: $e");
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}