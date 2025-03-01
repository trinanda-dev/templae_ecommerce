import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/produk/produk_provider.dart';

import '../../../components/product_card.dart';
import '../../../models/Product.dart';
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProdukProvider>(
      builder: (context, produkProvider, child) {
        List<Product> popularProducts = produkProvider.products
          .where((product) => product.isPopular) // Hanya  produk populer
          .toList();

          return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(
                title: "Produk Populer",
                press: () {
                  Navigator.pushNamed(context, ProductsScreen.routeName);
                },
              ),
            ),
            if (popularProducts.isEmpty)
                Center(
                  child: Lottie.asset(
                    'assets/lottie/empty-cart.json',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                )
            else 
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...popularProducts.map((product) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ProductCard(
                        product: product,
                        onPress: () => Navigator.pushNamed(
                          context, 
                          DetailsScreen.routeName,
                          arguments: ProductDetailsArguments(
                            product: product,
                          ),
                        )
                      )
                    );
                  }).toList(),
                  const SizedBox(width: 20),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}