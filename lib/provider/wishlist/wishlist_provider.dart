import 'package:flutter/material.dart';
import 'package:shop_app/service/wishlist/wishlist_service.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistService _wishlistService = WishlistService();
  List<dynamic> _wishlist = [];
  bool _isLoading = false;

  List<dynamic> get wishlist => _wishlist;
  bool get isLoading => _isLoading;

  // Fungsi untuk toggle antara add dan remove produk ke wishlist
  Future<void> toggleWishlistStatus(int productId) async {
    // Cari apakah produk ada di wishlist
    final isInWishlist = _wishlist.any((item) => item['produk_id'] == productId);

    if (isInWishlist) {
      _wishlist.removeWhere((item) => item['produk_id'] == productId);
    } else {
      _wishlist.add({
        'produk_id': productId,
      });
    }

    notifyListeners();

    try {
      if (isInWishlist) {
        // Jika produk ada , hapus dari wishlist backend
        await _wishlistService.removeFromWishlist(productId);
      } else {
        // Jika produk tidak ada, tambahkan ke wishlist backend
        await _wishlistService.addToWishlist(productId);
      }
    } catch (e) {
      // Rollback jika operasi gagal
      if (isInWishlist) {
        _wishlist.add({
          'produk_id': productId
        }
        );
      } else {
        _wishlist.removeWhere((item) => item['produk_id'] == productId);
      }
      notifyListeners();
      throw Exception('Gagal mengubah status wishlist: $e');
    }
  }

  Future<void> fetchWishlist() async {
    try {
      _isLoading = true;
      notifyListeners();
      _wishlist = await _wishlistService.getWishlist();
    } catch (e) {
      throw Exception('Gagal mendapatkan wishlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi yang digunakan untuk menambahkan wishlist
  Future<void> addToWishlist(int productId) async {
    try {
      final result = await _wishlistService.addToWishlist(productId);
      if (result['success']) {
        await fetchWishlist();
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      throw Exception('Gagal menambahkan ke wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    try {
      final result = await _wishlistService.removeFromWishlist(productId);
      if (result['success']) {
        await fetchWishlist();
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      throw Exception('Gagal menghapus dari wishlist: $e');
    }
  }
}
