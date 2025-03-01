import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:shop_app/provider/reset_password/reset_password_provider.dart';

import '../../../components/form_error.dart';
import '../reset_password/reset_password_screen.dart';

class VerifyTokenScreen extends StatefulWidget {
  static String routeName = "/verify_token";

  const VerifyTokenScreen({super.key});

  @override
  State<VerifyTokenScreen> createState() => _VerifyTokenScreenState();
}

class _VerifyTokenScreenState extends State<VerifyTokenScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? token;

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
      appBar: AppBar(title: const Text("Verifikasi Token")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Masukkan Token Reset Password",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // **Input Token**
              TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (newValue) => token = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: "Token tidak boleh kosong.");
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: "Token tidak boleh kosong.");
                    return "";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Token",
                  hintText: "Masukkan token",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),

              const SizedBox(height: 8),

              // **Tampilkan Pesan Error**
              FormError(errors: errors),

              const SizedBox(height: 8),

              // **Tombol Verifikasi**
              ElevatedButton(
                onPressed: resetPasswordProvider.isLoading ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    KeyboardUtil.hideKeyboard(context);

                    try {
                      await resetPasswordProvider.verifyResetCode("", token!);
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: const ResetPasswordScreen(),
                        ),
                      );
                    } catch (e) {
                      // Handle error supaya lebih user-friendly
                      setState(() {
                        if (e.toString().contains("invalid")) {
                          addError(error: "Token tidak valid.");
                        } else if (e.toString().contains("expired")) {
                          addError(error: "Token sudah kadaluarsa.");
                        } else {
                          addError(error: "Token tidak valid atau kadaluarsa.");
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
                        "Verifikasi",
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