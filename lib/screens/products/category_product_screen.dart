import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/provider/brand/brand_provider.dart';
import 'package:shop_app/screens/details/details_screen.dart';

class CategoryProductScreen extends StatefulWidget {
  final int categoryId; // ✅ Tambahkan parameter categoryId
  final String categoryName; // ✅ Tambahkan parameter categoryName


  const CategoryProductScreen({
    super.key,
    required this.categoryId, // ✅ Pastikan categoryId wajib diisi
    required this.categoryName, // ✅ Pastikan categoryName wajib diisi
  });

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductsByBrand();
  }

  Future<void> _fetchProductsByBrand() async {
    try {
      await Provider.of<BrandProvider>(context, listen: false)
          .fetchProductsByBrand(widget.categoryId);
    } catch (e) {
      debugPrint("Gagal mengambil produk berdasarkan category: $e");
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
          widget.categoryName, // ✅ Tampilkan nama brand di app bar
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Muli'
          ),
        ),
        titleSpacing: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 24,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
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
                ? const Center(child: Text("Tidak ada produk ditemukan"))
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
