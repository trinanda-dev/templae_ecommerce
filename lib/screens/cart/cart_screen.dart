import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart/cart_provider.dart';
import 'components/cart_card.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Ambil data keranjang saat halaman dimulai
    Future.microtask(() =>
        Provider.of<CartProvider>(context, listen: false).fetchCartItem());
  }

  Future<void> _refreshCart() async {
    await Provider.of<CartProvider>(context, listen: false).fetchCartItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Column(
              children: [
                Text(
                  "Your Cart",
                  style: Theme.of(context).textTheme.titleLarge
                ),
                Text(
                  "${cartProvider.cartItem.length} items",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
        titleSpacing: 0,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _refreshCart,
                  displacement: 0,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    // Jika keranjang kosong, tampilkan pesan kosong di tengah layar
                    child: cartProvider.cartItem.isEmpty
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Center(
                                child: Lottie.asset(
                                  'assets/lottie/empty-cart.json',
                                  width: 250,
                                  height: 205,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: cartProvider.cartItem.length,
                            itemBuilder: (context, index) {
                              final cartItem = cartProvider.cartItem[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Dismissible(
                                  key: Key(cartItem['id'].toString()),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) async {
                                    try {
                                      await Provider.of<CartProvider>(context,
                                              listen: false)
                                          .removeFromCart(
                                        cartItem['id'],
                                        cartItem['produk']['id'],
                                      );
                                    } catch (e) {
                                      throw Exception(
                                          'Gagal menghapus dari keranjang: $e');
                                    }
                                  },
                                  background: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFE6E6),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        SvgPicture.asset(
                                            "assets/icons/Trash.svg"),
                                      ],
                                    ),
                                  ),
                                  child: CartCard(cart: cartItem),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                // Loading indicator kecil di atas saat sedang loading
                if (cartProvider.isLoading)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Lottie.asset(
                          'assets/lottie/loading-2.json',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return cartProvider.cartItem.isNotEmpty
              ? const CheckoutCard()
              : const SizedBox.shrink();
        },
      ),
    );
  }
}