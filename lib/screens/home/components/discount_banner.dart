import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/discount_banner/discount_banner_provider.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscountBannerProvider>(
      builder: (context, discountedBannerProvider, child) {
        if (discountedBannerProvider.discountBanner.isEmpty) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF4A3298),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(color: Colors.white),
                  children: [
                    TextSpan(text: "Belum ada promo\n"),
                  ],
                ),
              ),
            )
          );
        }
        // Misalnya, kita gunakan banner pertama dari list
        final banner = discountedBannerProvider.discountBanner[0];
        final String title = banner['title'] ?? "";
        final String description = banner['description'] ?? "";

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF4A3298),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text.rich(
            TextSpan(
              style: const TextStyle(color: Colors.white),
              children: [
                TextSpan(text: "$title\n"),
                TextSpan(
                  text: description,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}