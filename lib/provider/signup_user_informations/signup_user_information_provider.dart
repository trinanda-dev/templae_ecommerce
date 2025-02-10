import 'package:flutter/material.dart';

class SignupUserInformationProvider with ChangeNotifier {
  String? _name;
  String? _storeName;
  String? _phoneNumber; // Menyimpan kode undangan dari tahap sebelumnya

  // Getter
  String? get name => _name;
  String? get storeName => _storeName;
  String? get phoneNumber => _phoneNumber;

  // Setter untuk menyimpan data sementara
  void setSignUpData({String? name, String? storeName, String? phoneNumber}) {
    _name = name;
    _storeName = storeName;
    _phoneNumber = phoneNumber;
    notifyListeners();
  }
}