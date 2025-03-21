import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/alamat/alamat_provider.dart';
import 'package:shop_app/provider/auth_provider/auth_provider.dart';
import 'package:shop_app/provider/brand/brand_provider.dart';
import 'package:shop_app/provider/cart/cart_provider.dart';
import 'package:shop_app/provider/category/category_provider.dart';
import 'package:shop_app/provider/discount_banner/discount_banner_provider.dart';
import 'package:shop_app/provider/invitation_code_provider/invitation_code_provider.dart';
import 'package:shop_app/provider/pengguna/pengguna_provider.dart';
import 'package:shop_app/provider/pesanan/pesanan_provider.dart';
import 'package:shop_app/provider/produk/produk_provider.dart';
import 'package:shop_app/provider/raja_ongkir_provider/raja_ongkir_provider.dart';
import 'package:shop_app/provider/reset_password/reset_password_provider.dart';
import 'package:shop_app/provider/signup_provider/signup_provider.dart';
import 'package:shop_app/provider/signup_user_informations/signup_user_information_provider.dart';
import 'package:shop_app/provider/wishlist/wishlist_provider.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';

import 'routes.dart';
import 'theme.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InvitationCodeProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => SignupUserInformationProvider()),
        ChangeNotifierProvider(create: (_) => RajaOngkirProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()),
        ChangeNotifierProvider(create: (_) => ProdukProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AlamatProvider()),
        ChangeNotifierProvider(create: (_) => PenggunaProvider()),
        ChangeNotifierProvider(create: (_) => DiscountBannerProvider()),
        ChangeNotifierProvider(create: (_) => PesananProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
      ],
      child:  const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TeraTani',
      theme: AppTheme.lightTheme(context),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}