import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart/cart_provider.dart';
import 'package:shop_app/provider/pesanan/pesanan_provider.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/validasi_ongkir/validasi_ongkir_screen.dart';

import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchField()),
          const SizedBox(width: 16),

          // 🔥 Ikon Keranjang dengan Jumlah Dinamis
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return IconBtnWithCounter(
                svgSrc: "assets/icons/Cart Icon.svg",
                numOfitem: cartProvider.cartItem.length,
                press: () => Navigator.pushNamed(context, CartScreen.routeName),
              );
            },
          ),

          const SizedBox(width: 8),

          // 🔥 Ikon Bell untuk Ongkir yang Belum Divalidasi
          Consumer<PesananProvider>(
            builder: (context, pesananProvider, child) {
              // 🔥 Hitung jumlah pesanan yang masih "Menunggu Validasi Admin"
              final int pendingValidations = pesananProvider.pesananList
                  .where((p) => p['status'] == "Menunggu Validasi Admin")
                  .length;

              return IconBtnWithCounter(
                svgSrc: "assets/icons/Bell.svg",
                numOfitem: pendingValidations, // 🔥 Jumlah dinamis
                press: () {
                  if (pendingValidations > 0) {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: ValidasiOngkirScreen(
                          pesananId: pesananProvider.pesananList.first['id'],
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Tidak ada ongkir yang perlu divalidasi.",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.grey,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}