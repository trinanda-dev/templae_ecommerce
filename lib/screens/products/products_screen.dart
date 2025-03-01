import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/provider/produk/produk_provider.dart';
import 'package:shop_app/screens/home/components/search_field.dart';
import '../details/details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  static String routeName = "/products";

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProdukProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, size: 20),
              ),
              Expanded(
                child: SearchField(
                  controller: _searchController,
                  isInProductScreen: true,
                  onChanged: (query) {
                    Provider.of<ProdukProvider>(context, listen: false)
                        .fetchProducts(search: query);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<ProdukProvider>(
          builder: (context, produkProvider, child) {
            if (produkProvider.isLoading) {
              return Center(
                child: Lottie.asset(
                  'assets/lottie/loading-2.json',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              );
            }

            if (produkProvider.products.isEmpty) {
              return Center(
                child: Lottie.asset(
                  'assets/lottie/empty-cart.json',
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: produkProvider.products.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final product = produkProvider.products[index];

                  return ProductCard(
                    product: product,
                    onPress: () {
                      Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments: ProductDetailsArguments(product: product),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}