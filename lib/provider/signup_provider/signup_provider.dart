import 'package:flutter/material.dart';

class SignUpProvider with ChangeNotifier {
  String? _email;
  String? _password;
  String? _invitationCode; // Menyimpan kode undangan dari tahap sebelumnya

  // Getter
  String? get email => _email;
  String? get password => _password;
  String? get invitationCode => _invitationCode;

  // Setter untuk menyimpan data sementara
  void setSignUpData({String? email, String? password}) {
    _email = email;
    _password = password;
    notifyListeners();
  }

  void setInvitationCode(String code) {
    _invitationCode = code;
    notifyListeners();
  }
}