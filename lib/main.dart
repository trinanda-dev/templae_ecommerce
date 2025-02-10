import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider/auth_provider.dart';
import 'package:shop_app/provider/brand/brand_provider.dart';
import 'package:shop_app/provider/category/category_provider.dart';
import 'package:shop_app/provider/invitation_code_provider/invitation_code_provider.dart';
import 'package:shop_app/provider/raja_ongkir_provider/raja_ongkir_provider.dart';
import 'package:shop_app/provider/signup_provider/signup_provider.dart';
import 'package:shop_app/provider/signup_user_informations/signup_user_information_provider.dart';
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
        ChangeNotifierProvider(create: (_) => BrandProvider())
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
      title: 'The Flutter Way - Template',
      theme: AppTheme.lightTheme(context),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}