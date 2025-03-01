import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:shop_app/provider/reset_password/reset_password_provider.dart';

import '../../../components/form_error.dart';
import '../../sign_in/sign_in_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String routeName = "/reset_password";

  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? password;
  String? confirmPassword;

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final resetPasswordProvider = Provider.of<ResetPasswordProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Masukkan Password Baru",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // **Input Password Baru**
              TextFormField(
                obscureText: true,
                onSaved: (newValue) => password = newValue,
                onChanged: (value) {
                  if (value.length >= 8) {
                    removeError(error: "Password minimal 8 karakter.");
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: "Password tidak boleh kosong.");
                    return "";
                  }
                  if (value.length < 8) {
                    addError(error: "Password minimal 8 karakter.");
                    return "";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Password Baru",
                  hintText: "Masukkan password baru",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),

              const SizedBox(height: 16),

              // **Input Konfirmasi Password**
              TextFormField(
                obscureText: true,
                onSaved: (newValue) => confirmPassword = newValue,
                onChanged: (value) {
                  if (value == password) {
                    removeError(error: "Konfirmasi password tidak cocok.");
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: "Konfirmasi password tidak boleh kosong.");
                    return "";
                  }
                  if (password != null && value != password) {
                    addError(error: "Konfirmasi password tidak cocok.");
                    return "";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Password",
                  hintText: "Masukkan kembali password",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),

              const SizedBox(height: 8),

              // **Tampilkan Pesan Error**
              FormError(errors: errors),

              const SizedBox(height: 8),

              // **Tombol Simpan Password**
              ElevatedButton(
                onPressed: resetPasswordProvider.isLoading ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    KeyboardUtil.hideKeyboard(context);

                    try {
                      await resetPasswordProvider.resetPassword(
                          password!, confirmPassword!);
                      Navigator.pushNamed(
                        context,
                        SignInScreen.routeName,
                      );
                    } catch (e) {
                      setState(() {
                        if (e.toString().contains("not match")) {
                          addError(error: "Password tidak cocok.");
                        } else {
                          addError(error: "Terjadi kesalahan. Coba lagi.");
                        }
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: resetPasswordProvider.isLoading
                      ? Colors.grey.shade400 // **Abu-abu saat loading**
                      : kPrimaryColor,
                ),
                child: resetPasswordProvider.isLoading
                    ? Lottie.asset(
                        'assets/lottie/loading-2.json',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      )
                    : const Text(
                        "Simpan",
                        style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}