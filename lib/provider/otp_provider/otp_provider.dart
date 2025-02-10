// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class OtpProvider with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String? _verificationId;
//   bool _isOtpSent = false;
//   bool _isVerifying = false;
//   String? _errorMessage;

//   String? get verificationId => _verificationId;
//   bool get isOtpSent => _isOtpSent;
//   bool get isVerifying => _isVerifying;
//   String? get errorMessage => _errorMessage;

//   /// **Mengirim OTP ke nomor HP**
//   Future<void> sendOtp(String? phoneNumber) async {
//     _isOtpSent = false;
//     _errorMessage = null;
//     notifyListeners();

//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         _isOtpSent = true;
//         notifyListeners();
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         _errorMessage = e.message;
//         notifyListeners();
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         _verificationId = verificationId;
//         _isOtpSent = true;
//         notifyListeners();
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         _verificationId = verificationId;
//       },
//     );
//   }

//   /// **Verifikasi OTP**
//   Future<bool> verifyOtp(String otpCode) async {
//     if (_verificationId == null) {
//       _errorMessage = "Verification ID tidak ditemukan.";
//       notifyListeners();
//       return false;
//     }

//     _isVerifying = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: otpCode,
//       );

//       await _auth.signInWithCredential(credential);
//       _isVerifying = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _errorMessage = "Kode OTP salah atau kadaluarsa.";
//       _isVerifying = false;
//       notifyListeners();
//       return false;
//     }
//   }
// }
