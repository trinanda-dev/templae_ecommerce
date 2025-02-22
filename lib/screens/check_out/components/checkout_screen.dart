// import 'package:flutter/material.dart';
// import 'package:shop_app/screens/check_out/components/adress_card.dart';
// import 'package:shop_app/screens/check_out/components/order_item_card.dart';
// import 'package:shop_app/screens/check_out/components/order_sumary_card.dart';

// class CheckoutScreen extends StatelessWidget {
//   const CheckoutScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Order Confirmation",
//           style: TextStyle(
//             fontFamily: 'Muli',
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Colors.black
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Center(
//               child: Column(
//                 children: [
//                   Icon(Icons.check_circle, size: 60, color: Colors.green),
//                   SizedBox(height: 8),
//                   Text("Thank you!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                   Text("Your order #BE12345 has been placed."),
//                   SizedBox(height: 8),
//                   Text(
//                     "We sent an email to orders@banuels.com with your order confirmation and bill.",
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Time placed
//             const Text("Time placed: 17/02/2020 12:45 CEST"),

//             const SizedBox(height: 16),

//             // Shipping Information
//             const Text(
//               "Shipping", 
//               style: TextStyle(
//                 fontSize: 16, 
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Muli'
//               )
//             ),
//             const SizedBox(height: 8),
//             const AddressCard(
//               name: "Banu Elson",
//               email: "orders@banuels.com",
//               phone: "+49 179 111 1010",
//               address: "Leibnizstraße 16, Wohnheim 6, No: 8X, Clausthal-Zellerfeld, Germany",
//             ),

//             const SizedBox(height: 16),

//             // Billing Information
//             const Text(
//               "Billing", 
//               style: TextStyle(
//                 fontSize: 16, 
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Muli'
//                 )
//               ),
//             const SizedBox(height: 8),
//             const AddressCard(
//               name: "Banu Elson",
//               email: "orders@banuels.com",
//               phone: "+49 179 111 1010",
//               address: "Leibnizstraße 16, Wohnheim 6, No: 8X, Clausthal-Zellerfeld, Germany",
//             ),

//             const SizedBox(height: 16),

//             // Order Items
//             const Text(
//               "Order Items", 
//               style: TextStyle(
//                 fontSize: 16, 
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Muli'
//                 )
//               ),
//             const SizedBox(height: 8),
//             const OrderItemCard(
//               imageUrl: "assets/images/placeholder.png",
//               title: "NikeCourt Lite 2",
//               color: "Blue",
//               size: "37",
//               quantity: 1,
//               price: 67.00,
//             ),
//             const SizedBox(height: 8),
//             const OrderItemCard(
//               imageUrl: "assets/images/placeholder.png",
//               title: "Wilson Hammer 5.3",
//               color: "Black",
//               size: "2-1/4",
//               quantity: 1,
//               price: 80.45,
//               oldPrice: 99.95,
//             ),

//             const SizedBox(height: 16),

//             // Order Summary
//             const OrderSummaryCard(
//               subtotal: 147.45,
//               shipping: 0.00,
//               total: 147.45,
//             ),

//             const SizedBox(height: 24),

//             // Back to Shopping Button
//             const SizedBox(height: 24),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               onPressed: () {}, 
//               child: const Text(
//                 "Kembali ke halaman utama",
//                 style: TextStyle(
//                   fontFamily: 'Muli',
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               )
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
