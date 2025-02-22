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
  Timer? _timer; // Timer untuk polling otomatis

  @override
  void initState() {
    super.initState();

    // Fetch pertama kali saat halaman dibuka
    Future.microtask(() =>
        Provider.of<PesananProvider>(context, listen: false)
            .fetchPesanan(widget.pesananId));

    // Polling setiap 5 detik
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      debugPrint("Polling pesanan...");
      final pesananProvider =
          Provider.of<PesananProvider>(context, listen: false);

      if (pesananProvider.hasUpdated) {
        debugPrint("Status pesanan telah diperbarui, menghentikan polling...");
        _timer?.cancel();
      } else {
        pesananProvider.fetchPesanan(widget.pesananId);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hentikan polling saat user meninggalkan halaman
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Muli',
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<PesananProvider>(
        builder: (context, pesananProvider, child) {
          final pesanan = pesananProvider.pesanan;

          if (pesananProvider.isLoading) {
            return Center(
              child: Lottie.asset(
                'assets/lottie/loading-2.json',
                height: 100,
                width: 100,
              )
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

          // Periksa apakah 'items' tidak null & memiliki data
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
                statusPesanan: pesanan['status'], // Kirim status pesanan
              ),
            ],
          );
        },
      ),
    );
  }
}
