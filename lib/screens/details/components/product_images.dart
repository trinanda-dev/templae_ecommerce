import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/produk/produk_provider.dart';

import '../../../constants.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    super.key,
    required this.productId,
  });

  final int productId;

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    // Ambil data dari provider
    final produkProvider = Provider.of<ProdukProvider>(context);
    final product = produkProvider.products.firstWhere(
      (prod) => prod.id == widget.productId,
      orElse: () => throw Exception('Product not found'),
    );

    return Column(
      children: [
        SizedBox(
          width: 238,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              product.images[selectedImage],
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
          ),
        ),
        // SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              product.images.length,
              (index) => SmallProductImage(
                isSelected: index == selectedImage,
                press: () {
                  setState(() {
                    selectedImage = index;
                  });
                },
                image: product.images[index],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class SmallProductImage extends StatelessWidget {
  const SmallProductImage({
    super.key,
    required this.isSelected,
    required this.press,
    required this.image,
  });

  final bool isSelected;
  final VoidCallback press;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(isSelected ? 1 : 0)),
        ),
        child: Image.network(
          image, // Pakai Image.network agar sesuai dengan API
          fit: BoxFit.cover,
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
      ),
    );
  }
}