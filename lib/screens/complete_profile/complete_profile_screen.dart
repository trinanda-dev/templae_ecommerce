import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/raja_ongkir_provider/raja_ongkir_provider.dart';

import '../../constants.dart';
import 'components/complete_profile_form.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";

  const CompleteProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final rajaOngkirProvider = Provider.of<RajaOngkirProvider>(context);

    // Fetch provinces when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rajaOngkirProvider.fetchProvinces();
    });

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
                  const CompleteProfileForm(),
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