import 'dart:async'; // ✅ Tambahkan untuk debounce
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shop_app/screens/products/products_screen.dart';
import '../../../constants.dart';

class SearchField extends StatefulWidget {
  final bool isInProductScreen;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchField({
    Key? key,
    this.controller,
    this.onChanged,
    this.isInProductScreen = false,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? _debounce; // ✅ Tambahkan debounce timer

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isInProductScreen
          ? null // Jika di halaman produk, biarkan bisa diketik
          : () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const ProductsScreen(),
                ),
              );
            },
      child: AbsorbPointer(
        absorbing: !widget.isInProductScreen, // ✅ Prevent input jika di Home
        child: TextFormField(
          controller: widget.controller,
          onChanged: (query) {
            if (widget.isInProductScreen && widget.onChanged != null) {
              // ✅ Gunakan debounce untuk search yang lebih efisien
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                widget.onChanged!(query);
              });
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: kSecondaryColor.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            border: searchOutlineInputBorder,
            focusedBorder: searchOutlineInputBorder,
            enabledBorder: searchOutlineInputBorder,
            hintText: "Cari Produk...",
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel(); // ✅ Hentikan debounce jika widget dihapus
    super.dispose();
  }
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);