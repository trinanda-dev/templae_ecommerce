import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromARGB(255, 95, 189, 49);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Colors.black;

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const labelStyle = TextStyle(
  fontSize: 16,
  color: kPrimaryColor,
  fontWeight: FontWeight.w400,
  height: 1.5,
);



const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp invitationCodeValidatorRegExp = 
    RegExp(r'^[A-Za-z0-9]{10}$');
final RegExp phoneNumberValidatorRegExp = 
    RegExp(r'^08[0-9]{8,11}$');
final RegExp postalCodeValidatorRegExp = 
    RegExp(r'^[0-9]{5}$');

const String kEmailNullError = "Masukkan email Anda";
const String kInvalidEmailError = "Masukkan email yang Valid";
const String kPassNullError = "Masukkan kata sandi Anda";
const String kShortPassError = "Kata sandi terlalu pendek";
const String kMatchPassError = "Kata sandi tidak cocok";
const String kNamelNullError = "Masukkan nama Anda";
const String kPhoneNumberNullError = "Masukkan nomor telepon Anda";
const String kInvalidPhoneNumber = "Nomor telpon tidak valid";
const String kAddressNullError = "Masukkan alamat lengkap Anda";
const String kInvitationCodeNullError = "Masukkan kode undangan Anda";
const String kInvalidInvitationCode = "Kode undangan tidak valid";
const String kStoreNameNullError = "Masukkan nama toko Anda";
const String kpostalCodeNullError = "Masukkan kode pos Anda";
const String kInvalidPostalCode = "Kode pos tidak valid";
const String kSubdistrictNullError = "Masukkan kecamatan Anda";


final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor),
  );
}
