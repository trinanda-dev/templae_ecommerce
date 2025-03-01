import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:shop_app/provider/reset_password/reset_password_provider.dart';
import 'package:shop_app/screens/forgot_password/verify_token/verify_token_screen.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../components/no_account_text.dart';
import '../../../constants.dart';

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  State<ForgotPassForm> createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;

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

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // **Input Email**
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } 
              if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } 
              if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Masukkan email Anda",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),

          const SizedBox(height: 8),

          // **Tampilkan pesan error**
          FormError(errors: errors),

          const SizedBox(height: 8),

          // **Tombol Submit**
          ElevatedButton(
            onPressed: resetPasswordProvider.isLoading ? null : () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                KeyboardUtil.hideKeyboard(context);

                try {
                  await resetPasswordProvider.sendResetCode(email!);
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: const VerifyTokenScreen(),
                    ),
                  );
                } catch (e) {
                  // Handle error berdasarkan respon API
                  setState(() {
                    if (e.toString().contains("not found")) {
                      addError(error: "Email tidak terdaftar.");
                    } else {
                      addError(error: "Email salah atau tidak terdaftar.");
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
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  )
                : const Text(
                    "Selanjutnya",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'Muli',
                    ),
                  ),
          ),

          const SizedBox(height: 16),

          // **Teks untuk pengguna tanpa akun**
          const NoAccountText(),
        ],
      ),
    );
  }
}