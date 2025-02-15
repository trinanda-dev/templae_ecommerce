import 'product.dart';

class Cart {
  final int id;
  final int produkId;
  final int jumlah;
  final Product product;

  Cart({
    required this.id,
    required this.produkId,
    required this.jumlah,
    required this.product,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      produkId: json['produk_id'],
      jumlah: json['jumlah'],
      product: Product.fromJson(json['produk']),
    );
  }
}