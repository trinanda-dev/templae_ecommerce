// import 'package:flutter/material.dart';

// class OrderItemCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String color;
//   final String size;
//   final int quantity;
//   final double price;
//   final double? oldPrice;

//   const OrderItemCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.color,
//     required this.size,
//     required this.quantity,
//     required this.price,
//     this.oldPrice,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Image.asset(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Text("Color: $color"),
//               Text("Size: $size"),
//               Text("Qty: $quantity"),
//             ],
//           ),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             if (oldPrice != null)
//               Text(
//                 "\$${oldPrice!.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                   decoration: TextDecoration.lineThrough,
//                 ),
//               ),
//             Text(
//               "\$${price.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 16, 
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Muli'
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }