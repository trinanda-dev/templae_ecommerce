import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/product_card.dart';
// import 'package:shop_app/models/Product.dart';
import 'package:shop_app/provider/produk/produk_provider.dart';

import '../details/details_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  static String routeName = "/products";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produk"),
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
                  'assets/lottie/empty.json',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
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
                        arguments: ProductDetailsArguments(
                          product: product,
                        )
                      );
                    },
                  );
                },
              ),
            );
          }
        )
      ),
    );
  }
}