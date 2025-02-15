import 'package:flutter/material.dart';
import '../../../components/rounded_icon_btn.dart';

class QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityControl({
    Key? key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Tombol untuk mengurangi jumlah
          RoundedIconBtn(
            icon: Icons.remove,
            press: onDecrement,
          ),
          const SizedBox(width: 20),
          // Tampilkan jumlah produk
          Text(
            '$quantity',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 20),
          // Tombol untuk menambah jumlah
          RoundedIconBtn(
            icon: Icons.add,
            showShadow: true,
            press: onIncrement,
          ),
        ],
      ),
    );
  }
}
