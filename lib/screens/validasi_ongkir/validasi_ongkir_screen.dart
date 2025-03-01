import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/pesanan/pesanan_provider.dart';
import 'package:shop_app/screens/validasi_ongkir/components/checkout_with_ongkir.dart';
import 'components/validasi_ongkir_card.dart';

class ValidasiOngkirScreen extends StatefulWidget {
  final int pesananId;

  const ValidasiOngkirScreen({super.key, required this.pesananId});

  @override
  State<ValidasiOngkirScreen> createState() => _ValidasiOngkirScreenState();
}

class _ValidasiOngkirScreenState extends State<ValidasiOngkirScreen> {
  Timer? _timer;
  bool _isFirstFetch = true; // 🔥 Cek apakah ini fetch pertama

  @override
  void initState() {
    super.initState();
    _fetchPesanan(firstFetch: true); // 🔥 Fetch pertama kali dengan loading

    // Polling setiap 5 detik tanpa loading animasi
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      debugPrint("Polling pesanan...");

      final pesananProvider =
          Provider.of<PesananProvider>(context, listen: false);

      if (pesananProvider.hasUpdated) {
        debugPrint("Status pesanan telah diperbarui, menghentikan polling...");
        _timer?.cancel();
      } else {
        _fetchPesanan(firstFetch: false); // 🔥 Polling tanpa loading
      }
    });
  }

  // 🔥 Fetch pesanan dengan opsi loading hanya untuk fetch pertama kali
  Future<void> _fetchPesanan({required bool firstFetch}) async {
    if (firstFetch) {
      setState(() {
        _isFirstFetch = true;
      });
    }

    await Provider.of<PesananProvider>(context, listen: false)
        .fetchPesanan(widget.pesananId);

    if (mounted) {
      setState(() {
        _isFirstFetch = false; // 🔥 Setelah fetch pertama kali, set false
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Detail Pesanan",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Consumer<PesananProvider>(
        builder: (context, pesananProvider, child) {
          final pesanan = pesananProvider.pesanan;

          // 🔥 Hanya tampilkan loading saat fetch pertama kali
          if (pesananProvider.isLoading && _isFirstFetch) {
            return  Center(
              child: Lottie.asset(
                'assets/lottie/loading-2.json',
                height: 100,
                width: 100
              )  // Ganti dengan loading kecil
            );
          }

          if (pesanan == null) {
            return const Center(
              child: Text(
                "Pesanan tidak ditemukan.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final List<dynamic> items = pesanan['items'] ?? [];

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 10),
                    if (items.isEmpty)
                      const Center(
                        child: Text(
                          "Tidak ada item dalam pesanan",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    else
                      ...List.generate(
                        items.length,
                        (index) => ValidasiOngkirCard(
                          pesananItem: items[index],
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              CheckoutWithOngkirCard(
                pesananId: pesanan['id'],
                totalHarga: double.parse(pesanan['total_harga'].toString()),
                ongkosKirim: double.parse(pesanan['ongkos_kirim'].toString()),
                grandTotal: double.parse(pesanan['grand_total'].toString()),
                statusPesanan: pesanan['status'],
              ),
            ],
          );
        },
      ),
    );
  }
}