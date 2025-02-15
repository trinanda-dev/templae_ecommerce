import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/provider/produk/produk_provider.dart';
import 'package:shop_app/provider/wishlist/wishlist_provider.dart';

import '../details/details_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWishlist();
    });
  }

  Future<void> _fetchWishlist() async {
    setState(() {
      _isLoading = true; // ✅ Aktifkan loading di atas
    });

    try {
      await Provider.of<WishlistProvider>(context, listen: false).fetchWishlist();
    } catch (e) {
      debugPrint("Gagal mengambil wishlist: $e");
    } finally {
      setState(() {
        _isLoading = false; // ✅ Matikan loading setelah selesai
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              return RefreshIndicator(
                onRefresh: _fetchWishlist, // ✅ Tarik ke bawah untuk refresh
                displacement: 50,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Text(
                      "Favorites",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Expanded(
                      child: wishlistProvider.wishlist.isEmpty
                          ? Center(
                              child: Lottie.asset(
                                'assets/lottie/empty-wishlist.json',
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16),
                              child: Consumer<ProdukProvider>(
                                builder: (context, produkProvider, child) {
                                  return GridView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: wishlistProvider.wishlist.length,
                                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 0.7,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 16,
                                    ),
                                    itemBuilder: (context, index) {
                                      // Ambil id dari wishlist
                                      final productId =
                                          wishlistProvider.wishlist[index]['produk_id'];

                                      // Cari produk berdasarkan ID di provider produk
                                      final product = produkProvider.products.firstWhere(
                                        (prod) => prod.id == productId,
                                        orElse: () => throw Exception(
                                          'Product dengan ID $productId tidak ditemukan',
                                        ),
                                      );

                                      return ProductCard(
                                        product: product,
                                        onPress: () => Navigator.pushNamed(
                                          context,
                                          DetailsScreen.routeName,
                                          arguments:
                                              ProductDetailsArguments(product: product),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Indikator Loading Lottie (Hanya muncul saat pertama kali buka)
          if (_isLoading)
            Positioned(
              top: 50,
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
      ),
    );
  }
}
