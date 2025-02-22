// import 'package:flutter/material.dart';

// class OrderSummaryCard extends StatelessWidget {
//   final double subtotal;
//   final double shipping;
//   final double total;

//   const OrderSummaryCard({
//     super.key,
//     required this.subtotal,
//     required this.shipping,
//     required this.total,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Order Summary",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Subtotal"),
//             Text("\$${subtotal.toStringAsFixed(2)}"),
//           ],
//         ),
//         const SizedBox(height: 4),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Shipping"),
//             Text("\$${shipping.toStringAsFixed(2)}"),
//           ],
//         ),
//         const Divider(),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               "Total",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               "\$${total.toStringAsFixed(2)}",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
