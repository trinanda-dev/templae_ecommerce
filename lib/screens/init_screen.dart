import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/favorite/favorite_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/transaksi/transaksi_screen.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    const TransaksiScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex, // 🔥 IndexedStack menyimpan state halaman
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: (index) => setState(() => _currentIndex = index), // 🔥 Hanya ubah index, tidak rebuild halaman
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavItem("assets/icons/Shop Icon.svg", "Home", 0),
          _buildNavItem("assets/icons/Heart Icon.svg", "Fav", 1),
          _buildNavItem("assets/icons/Transaction.svg", "Transaksi", 2),
          _buildNavItem("assets/icons/User Icon.svg", "Profile", 3),
        ],
      ),
    );
  }

  /// 🔹 Fungsi untuk membuat item BottomNavigationBar agar lebih rapih
  BottomNavigationBarItem _buildNavItem(String iconPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          _currentIndex == index ? kPrimaryColor : inActiveIconColor,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}