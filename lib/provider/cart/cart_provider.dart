import 'package:flutter/material.dart';
import 'package:shop_app/service/cart/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  List<Map<String, dynamic>> _cartItem = [];
  double _cartTotal = 0.0;
  List<int> _selectedItemIds = [];
  bool _isLoading = false;
  int? _latestPesananId;

  int? get latestPesananIId => _latestPesananId;
  List<Map<String, dynamic>> get cartItem => _cartItem;
  double get cartTotal => _cartTotal;
  List<int> get selectedItemIds => _selectedItemIds;
  bool get isLoading => _isLoading;

  // Mengubah status item terpilih
  void toggleSelectedItem(int itemId) {
    if (_selectedItemIds.contains(itemId)) {
      _selectedItemIds.remove(itemId);
    } else {
      _selectedItemIds.add(itemId);
    }
    notifyListeners();
  }

  // Mengatur semua item terpilih
  void setSelectedItems(List<int> itemIds) {
    _selectedItemIds = itemIds;
    notifyListeners();
  }

  // Fungsi untuk menambahkan jumlah produk
  Future<void> incrementQuantity(int cartItemId, int produkId) async {
    final cartItem = _cartItem.firstWhere((item) => item['id'] == cartItemId);

    var stok = cartItem['variant'] != null
      ? cartItem['variant']['variant_stock']
      : cartItem['produk']['stok']; // Gunakan stok dari produk

    if (stok > 0) {
      cartItem['jumlah'] += 1;
      notifyListeners();

      try {
        await _cartService.updateCartItem(
          cartItemId, 
          cartItem['jumlah'], 
          produkId,
        );
        await fetchCartItem();
      } catch (e) {
        cartItem['jumlah'] -= 1; // Rollback jika gagal
        notifyListeners();
        throw Exception('Gagal menambahkan item di keranjang: $e');
      }
    } else {
      throw Exception('Stok tidak mencukupi');
    }
    }

  // Fungsi untuk mengurangi jumlah produk
  Future<void> decrementQuantity(int cartItemId, int produkId) async {
    final cartItem = _cartItem.firstWhere((item) => item['id'] == cartItemId);

    if (cartItem['jumlah'] > 1) {
      // Optimistic update
      cartItem['jumlah'] -= 1;
      notifyListeners();

      try {
        // Upate ke backend
        await _cartService.updateCartItem(
          cartItemId, 
          cartItem['jumlah'], 
          produkId,
        );
        await fetchCartItem();
      } catch (e) {
        // Rollback jika gagal
        cartItem['jumlah'] += 1;
        notifyListeners();
        throw Exception('Gagal mengurangi item di keranjang: $e');
      }
    }
  }

  // Mendapatkan daftar item keranjang dengan filter
  Future<void> fetchCartItem() async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _cartService.getCartItem();

      // result['data'] -> list item keranjang
      _cartItem = (result['data'] as List).cast<Map<String, dynamic>>();

      // Tangkap 'total' dari respons API, ubah ke double
      final totalFromApi = result['total'];
      if (totalFromApi is int) {
        _cartTotal = totalFromApi.toDouble();
      } else if (totalFromApi is double) {
        _cartTotal = totalFromApi;
      } else if (totalFromApi is String) {
        _cartTotal = double.tryParse(totalFromApi) ?? 0.0;
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal mendapatkan daftar item di keranjang: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Menambahkan item ke dalam keranjang (cart)
  Future<void> addToCart(int productId,  {int jumlah = 1}) async {
    try {
      final result = await _cartService.addToCart(productId, jumlah: jumlah);
      if (result['success']) {
        await fetchCartItem();
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      throw Exception('Gagal menambahkan ke keranjang: $e');
    }
  }

  // Menghapus item dari keranjang
  Future<void> removeFromCart(int cartItemId, int productId) async {
    final originalCartItem = _cartItem.firstWhere((item) => item['id'] == cartItemId);

    _cartItem.removeWhere((item) => item['id'] == cartItemId);
    notifyListeners();

    try {
      // Kirim ke backend
      await _cartService.removeFromCart(
        cartItemId, 
        productId,
      );
    } catch (e) {
      // Rollback jika gagal
      _cartItem.add(originalCartItem);
      notifyListeners();
      throw Exception('Gagal menghapus dari keranjang: $e');
    }
  }

  // Fungsi yang digunakan untuk memanggil jumlah stock dari produk
  Future<int> getProductStock(int productId) async {
    try {
      final stock = await _cartService.getProductStock(productId);
      return stock;
    } catch (e) {
      throw Exception('Gagal mendapatkan stock produk: $e');
    }
  }

  // Method yang digunakan untuk memanggil jumlah cart item di dalam keranjang
  Future<Map<String, dynamic>> getQuantityCartItem() async {
    try {
      final result = await _cartService.getQuantityCartItem();
      return result;
    } catch (e) {
      throw Exception('Gagal mendapatkan jumlah cart item: $e');
    }
  }

  // Method yang digunakan untuk melakukan checkout terhadap produk di dalam keranjang
  Future<bool> checkout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _cartService.checkout();
      debugPrint("Checkout Response: $result"); // Debug response
      if (result.containsKey('success') && result['success'] == true) {
        _cartItem.clear();
        _cartTotal = 0.0;
        _latestPesananId = result['data']['id'];
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Checkout Error: $e"); // Debug error
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}