import 'package:flutter/material.dart';
import 'package:shop_app/helper/currency.dart';

class ValidasiOngkirCard extends StatelessWidget {
  final Map<String, dynamic> pesananItem;

  const ValidasiOngkirCard({super.key, required this.pesananItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(
                pesananItem['produk']['images'][0], // Gambar pertama dari produk
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pesananItem['produk']['nama'],
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Currency(
                      value: double.parse(pesananItem['harga_saat_checkout']),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: " x ${pesananItem['jumlah']}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}