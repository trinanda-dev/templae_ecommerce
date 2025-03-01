import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/wishlist/wishlist_provider.dart';

import '../../../constants.dart';
import '../../../models/Product.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _isExpanded = false; // 🔥 Status apakah deskripsi sedang full atau tidak
  bool _shouldShowSeeMore = false; // 🔥 Status apakah tombol "Lihat Selengkapnya" perlu ditampilkan

  @override
  void initState() {
    super.initState();
    _checkIfTextExceedsMaxLines();
  }

  // 🔥 Fungsi untuk mengecek apakah teks lebih dari 4 baris
  void _checkIfTextExceedsMaxLines() {
    final textSpan = TextSpan(
      text: widget.product.deskripsi,
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'Muli'
      ), // Pastikan sesuai dengan style asli
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 4, // Batas jumlah baris yang ingin dicek
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 400); // Sesuaikan maxWidth dengan layout aslinya

    if (textPainter.didExceedMaxLines) {
      setState(() {
        _shouldShowSeeMore = true; // 🔥 Jika teks melebihi 4 baris, tampilkan "Lihat Selengkapnya"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    // Cek apakah produk ada di wishlist
    final bool isInWishlist = wishlistProvider.wishlist.any(
      (item) => item['produk_id'] == widget.product.id,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.product.nama,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () async {
              // ✅ Toggle wishlist status dengan animasi
              await wishlistProvider.toggleWishlistStatus(widget.product.id);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              width: 48,
              decoration: BoxDecoration(
                color: isInWishlist
                    ? const Color(0xFFFFE6E6) // Warna saat ada di wishlist
                    : const Color(0xFFF5F6F9), // Warna default
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: SvgPicture.asset(
                "assets/icons/Heart Icon_2.svg",
                colorFilter: ColorFilter.mode(
                  isInWishlist
                      ? const Color(0xFFFF4848) // Warna merah jika favorit
                      : const Color(0xFFDBDEE4), // Warna default
                  BlendMode.srcIn,
                ),
                height: 16,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 64),
          child: Text(
            widget.product.deskripsi,
            maxLines: _isExpanded ? null : 4, // 🔥 Jika isExpanded = true, tampilkan semua
            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
        if (_shouldShowSeeMore) // 🔥 Hanya tampilkan jika teks lebih dari 4 baris
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded; // 🔥 Toggle expand/collapse
                });
              },
              child: Row(
                children: [
                  Text(
                    _isExpanded ? "Lihat Lebih Sedikit" : "Lihat Selengkapnya",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                      fontFamily: 'Muli'
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    _isExpanded ? Icons.arrow_upward : Icons.arrow_forward_ios,
                    size: 12,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
