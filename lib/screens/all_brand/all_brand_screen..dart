import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/brand/brand_provider.dart';
import 'package:shop_app/screens/products/brand_product_screen.dart';

class AllBrandScreen extends StatelessWidget {
  const AllBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Brand"),
      ),
      body: Consumer<BrandProvider>(
        builder: (context, brandProvider, child) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 0),
            itemCount: brandProvider.brands.length,
            itemBuilder: (context, index) {
              final brand = brandProvider.brands[index];
              return VerticalBrandCard(
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
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class VerticalBrandCard extends StatelessWidget {
  const VerticalBrandCard({
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
    // Menggunakan AspectRatio untuk memastikan proporsi yang konsisten
    return AspectRatio(
      aspectRatio: 3, // Anda bisa sesuaikan perbandingan (misalnya 16/9 atau 3)
      child: GestureDetector(
        onTap: press,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            // LayoutBuilder untuk mendapatkan ukuran kartu secara dinamis
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;
                return Stack(
                  children: [
                    Center(
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),                    
                    // Overlay gradient untuk meningkatkan kontras teks
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
                    // Padding dan posisi teks berdasarkan tinggi kartu
                    Padding(
                      padding: EdgeInsets.all(height * 0.15),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: height * 0.15, // ukuran font relatif
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.05),
                            Text(
                              "$numOfBrands Produk",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: height * 0.13, // ukuran font relatif
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}