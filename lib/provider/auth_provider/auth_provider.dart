import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/service/auth_service/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService(
    client: http.Client(),
  );

  bool _isLoggedIn = false;
  bool _isLoading = false;

  // Getter untuk user

  // Getter untuk kondisi _isLoggedIn
  bool get isLoggedIn => _isLoggedIn;

  // Getter untuk kondisi _isLoading
  bool get isLoading => _isLoading;


  // Fungsi provider untuk melakukan login
  Future<void> login(String emailOrPhone, String password) async {
    _isLoading = true;
    notifyListeners();
     try {
      final response = await _authService.login(emailOrPhone, password);

      if(response['status'] == 'success') {
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method yang digunakan untuk melakukan sign up
  // Fungsi provider untuk melakukan signup
  Future<void> signUp(
    String name,
    String email,
    String password,
    String passwordConfirm,
    String invitationCode,
    String storeName,
    String phoneNumber,
    String address,
    String cityId,
    String city,
    String provinceId,
    String province,
    String postalCode,
    ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.signUp(
        name: name,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
        invitationCode: invitationCode,
        storeName: storeName,
        phoneNumber: phoneNumber,
        address: address,
        cityId: cityId,
        city: city,
        provinceId: provinceId,
        province: province,
        postalCode: postalCode,
      );

      if (response['status'] == 'success') {
        notifyListeners(); // Beritahu UI
      } else if (response['error'] != null) {
        throw Exception(response['error']);
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method yang digunkan untuk melakukan logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.logout();
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}