import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/signup_user_information_form.dart';

class SignupUserInformationScreen extends StatelessWidget {
  static String routeName = "/signup_user_information";

  const SignupUserInformationScreen({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text("Complete Profile", style: headingStyle),
                  const Text(
                    "Lengkapi informasi akun Anda \ndi bawah ini",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const SignupUserInformationForm(),
                  const SizedBox(height: 30),
                  Text(
                    "Dengan melanjutkan, Anda menyetujui \ndengann syarat dan ketentuan aplikasi Kami",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}