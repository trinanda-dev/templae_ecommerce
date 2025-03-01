import 'package:flutter/material.dart';

import '../../components/no_account_text.dart';
import 'components/sign_form.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: const SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Sign in dengan email dan password \natau lanjutkan dengan sosial media",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  SignForm(),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SocalCard(
                      //   icon: "assets/icons/google-icon.svg",
                      //   press: () {},
                      // ),
                      // SocalCard(
                      //   icon: "assets/icons/facebook-2.svg",
                      //   press: () {},
                      // ),
                      // SocalCard(
                      //   icon: "assets/icons/twitter.svg",
                      //   press: () {},
                      // ),
                    ],
                  ),
                  SizedBox(height: 20),
                  NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
