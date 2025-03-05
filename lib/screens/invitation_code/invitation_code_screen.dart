import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/invitation_code/components/invitation_code_form.dart';

class InvitationCodeScreen extends StatelessWidget {
  static String routeName = "/invitation_code";

  const InvitationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kode Undangan"),
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
                  const Text("Kode Undangan", style: headingStyle),
                  const Text(
                    "Isi kode undangan Anda \nuntuk melanjutkan ke aplikasi",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const InvitationCodeForm(),
                  const SizedBox(height: 16),
                  Text(
                    "Dengan melanjutkan, Anda menyetujui \nterhadap syarat dan ketentuan aplikasi Kami",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ]
              )
            )
          )
        ),
      ),
    );
  }
}