import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider/auth_provider.dart';
import 'package:shop_app/screens/akun/akun_screen.dart';
import 'package:shop_app/screens/akun/alamat/alamat_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Akun saya",
              icon: "assets/icons/User Icon.svg",
              press: () => {
                Navigator.push(
                  context, 
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const EditProfileDataScreen()
                  )
                )
              },
            ),
            ProfileMenu(
              text: "Alamat",
              icon: "assets/icons/alamat.svg",
              press: () {
                Navigator.push(
                  context, 
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const AlamatScreen()
                  )
                );
              },
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () async {
                const String phoneNumber = '6281270416699';
                const String message = 'Halo, saya membutuhkan bantuan dari TeraTani Care.';
                final Uri whatsappUri = Uri.parse(
                  'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
                );

                if (await canLaunchUrl(whatsappUri)) {
                  await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                } else if (context.mounted) { // Tambahkan pengecekan ini
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tidak dapat membuka WhatsApp'),
                    ),
                  );
                }
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async {
                // Tampilkan loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false, 
                  builder: (context) => Center(
                    child: Lottie.asset(
                      'assets/lottie/loading.json',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                );

                try {
                  // Panggil logout dari provider
                  await Provider.of<AuthProvider>(context, listen: false).logout();

                  // Setelah logout, navigasi ke halaman Signin dan hapus seluruh route sebelumnya
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SignInScreen.routeName,
                    (route) => false,
                  );
                } catch (e) {
                  // Hapus loading dialig jika terjadi error
                  Navigator.pop(context);
                  Center(
                    child: Container(
                      child: Lottie.asset(
                        'assets/lottie/signup_error.json',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}