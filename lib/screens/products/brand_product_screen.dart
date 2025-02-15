import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/provider/brand/brand_provider.dart';
import 'package:shop_app/screens/details/details_screen.dart';

class BrandProductScreen extends StatefulWidget {
  final int brandId; // ✅ Tambahkan parameter brandId
  final String brandName; // ✅ Tambahkan parameter brandName


  const BrandProductScreen({
    super.key,
    required this.brandId, // ✅ Pastikan brandId wajib diisi
    required this.brandName, // ✅ Pastikan brandName wajib diisi
  });

  @override
  State<BrandProductScreen> createState() => _BrandProductScreenState();
}

class _BrandProductScreenState extends State<BrandProductScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductsByBrand();
  }

  Future<void> _fetchProductsByBrand() async {
    try {
      await Provider.of<BrandProvider>(context, listen: false)
          .fetchProductsByBrand(widget.brandId);
    } catch (e) {
      debugPrint("Gagal mengambil produk berdasarkan brand: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandProvider = Provider.of<BrandProvider>(context);
    final products = brandProvider.productBrands;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.brandName, // ✅ Tampilkan nama brand di app bar
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
              child: Lottie.asset(
                'assets/lottie/loading-2.json',
                width: 100,
                height: 100,
              )
            )
            : products.isEmpty
                ? const Center(child: Text("Tidak ada produk ditemukan."))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return ProductCard(
                          product: product,
                          onPress: () {
                            Navigator.pushNamed(
                              context,
                              DetailsScreen.routeName,
                              arguments: ProductDetailsArguments(
                                product: product,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
