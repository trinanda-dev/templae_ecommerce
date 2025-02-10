import 'package:flutter/material.dart';
import 'package:shop_app/service/invitation_code_service/invitation_code_service.dart';
import 'package:http/http.dart' as http;

class InvitationCodeProvider with ChangeNotifier {
  final InvitationCodeService _invitationCodeService = InvitationCodeService(
    client: http.Client(),
  );

  bool _isCodeValid = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getter
  bool get isCodeValid => _isCodeValid;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fungsi untuk validasi kode undangan
  Future<void> validateCode(String kodeUndangan) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool isValid = await _invitationCodeService.validateInvitationCode(kodeUndangan);
      
      if (isValid) {
        _isCodeValid = true;
      } else {
        _isCodeValid = false;
        _errorMessage = "Kode undangan tidak valid";
      }
      
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isCodeValid = false;
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }
}