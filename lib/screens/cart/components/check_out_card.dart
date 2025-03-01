import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper/currency.dart';
import 'package:shop_app/screens/validasi_ongkir/validasi_ongkir_screen.dart';
import '../../../constants.dart';
import '../../../provider/cart/cart_provider.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            final total = cartProvider.cartTotal;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SvgPicture.asset("assets/icons/receipt.svg"),
                    ),
                    const Spacer(),
                    const Text("Add voucher code"),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: kTextColor,
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          children: [
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Currency(
                                    value: double.parse(total.toString()),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: cartProvider.isLoading
                            ? null // Matikan tombol jika sedang loading
                            : () async {
                                bool checkoutSuccess = await cartProvider.checkout();
                                if (checkoutSuccess) {
                                  final pesananId = cartProvider.latestPesananIId;

                                  // Navigasi ke halaman validasi ongkir
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: ValidasiOngkirScreen(
                                        pesananId: pesananId!,
                                      ),
                                    ),
                                  );
                                }
                              },
                        child: cartProvider.isLoading
                            ? SizedBox(
                                height: 40,
                                width: 40,
                                child: Lottie.asset(
                                  'assets/lottie/loading-2.json',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Text(
                                "Checkout",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Muli'
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}