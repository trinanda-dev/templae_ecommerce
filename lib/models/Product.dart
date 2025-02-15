class Product {
  final int id;
  final String nama, deskripsi;
  final List<String> images;
  final double rating, harga;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.nama,
    required this.harga,
    required this.deskripsi,
  });

  // Mapping dari JSON(API) ke model Flutter
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      harga: double.parse(json['harga'].toString()), // Pastikan format harga sesuai
      rating: double.parse(json['rating'].toString()), // Rating tetap
      isPopular: json['is_popular'] ?? false, // Gunakan data dari backend
    );
  }
}