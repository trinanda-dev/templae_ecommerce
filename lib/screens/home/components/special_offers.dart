import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/brand/brand_provider.dart';
import 'package:shop_app/screens/all_brand/all_brand_screen..dart';
import 'package:shop_app/screens/products/brand_product_screen.dart';
import 'package:lottie/lottie.dart';

import 'section_title.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandProvider>(
      builder: (context, brandProvider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(
                title: "Spesial untukmu",
                press: () {
                  Navigator.push(
                    context, 
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: const AllBrandScreen(),
                    )
                  );
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...brandProvider.brands.map((brand) {
                    return SpecialOfferCard(
                      image: brand['image'] ?? '',
                      category: brand['nama'],
                      numOfBrands: brand['produks_count'] ?? 0,
                      press: () {
                        Navigator.push(
                          context, 
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: BrandProductScreen(
                              brandId: brand['id'],
                              brandName: brand['nama'],
                            )
                          ),
                        );
                      },
                    );
                  }).toList(),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
    
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    super.key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  });

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 242,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.network(
                  image,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    // Tampilkan placeholder jika gagal memuat gambar
                    return Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.cover,
                    ); 
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: Lottie.asset(
                        'assets/lottie/loading-2.json',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover
                      )
                    );
                  },
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.black38,
                        Colors.black26,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfBrands Produk")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
