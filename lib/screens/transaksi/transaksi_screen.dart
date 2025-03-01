import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper/currency.dart';
import 'package:shop_app/provider/pesanan/pesanan_provider.dart';
import 'package:shop_app/screens/unggah_bukti_transfer/unggah_bukti_transfer_screen.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Menunda pemanggilan _fetchPesanan hingga setelah frame selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPesanan();
    });
  }

  Future<void> _fetchPesanan() async {
    if (!mounted) return; // 🔥 Mencegah setState jika widget sudah dihapus
    setState(() {
      _isRefreshing = true;
    });

    await Provider.of<PesananProvider>(context, listen: false).fetchAllPesanan();

    if (!mounted) return;
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PesananProvider>(
      builder: (context, pesananProvider, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Transaksi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              tabs: const [
                Tab(text: 'Berhasil'),
                Tab(text: 'Gagal'),
                Tab(text: 'Ongkir'),
                Tab(text: 'Pembayaran',)
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              PesananList(
                pesananProvider.pesananList
                    .where((p) => p['status'] == 'Berhasil')
                    .toList(),
                onRefresh: _fetchPesanan,
                isRefreshing: _isRefreshing,
              ),
              PesananList(
                pesananProvider.pesananList
                    .where((p) => p['status'] == 'Gagal')
                    .toList(),
                onRefresh: _fetchPesanan,
                isRefreshing: _isRefreshing,
              ),
              PesananList(
                pesananProvider.pesananList
                    .where((p) => p['status'] == 'Menunggu Validasi Admin')
                    .toList(),
                onRefresh: _fetchPesanan,
                isRefreshing: _isRefreshing,
              ),
              PesananList(
                pesananProvider.pesananList
                    .where((p) => p['status'] == 'Menunggu Pembayaran')
                    .toList(),
                onRefresh: _fetchPesanan,
                isRefreshing: _isRefreshing,
                isPembayaranTab: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

// 🔥 **Widget untuk menampilkan daftar pesanan dengan RefreshIndicator**
class PesananList extends StatelessWidget {
  final List<Map<String, dynamic>> pesananList;
  final Future<void> Function()? onRefresh;
  final bool isRefreshing;
  final bool isPembayaranTab;

  const PesananList(
    this.pesananList, {
    this.onRefresh,
    this.isRefreshing = false,
    this.isPembayaranTab = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.green,
      onRefresh: onRefresh ?? () async {},
      child: Column(
        children: [
          if (isRefreshing)
            const SizedBox(height: 10), // 🔹 Memberi ruang agar loading dan refresh sejajar
          Expanded(
            child: pesananList.isEmpty
                ? Center(
                    child: Lottie.asset(
                      'assets/lottie/empty-cart.json',
                      height: 200,
                      width: 200,
                    ),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: pesananList.length,
                    itemBuilder: (context, index) {
                      var pesanan = pesananList[index];
                      var produk = (pesanan['produk'] != null && pesanan['produk'].isNotEmpty)
                          ? pesanan['produk'][0]
                          : null;

                      return Card(
                        color: Colors.white,
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (produk != null)
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    produk['images'][0],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image),
                                  ),
                                ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            produk != null ? produk['nama_produk'] : 'Produk Tidak Tersedia',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Muli',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: pesanan['status'] == 'Berhasil'
                                                ? Colors.green.withOpacity(0.2)
                                                : pesanan['status'] == 'Gagal'
                                                    ? Colors.red.withOpacity(0.2)
                                                    : pesanan['status'] == 'Menunggu Validasi Admin'
                                                      ? Colors.orange.withOpacity(0.2)
                                                      : Colors.blue.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            pesanan['status'],
                                            style: const TextStyle(
                                              fontFamily: 'Muli',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (produk != null) ...[
                                      Row(
                                        children: [
                                          const Text("Total: ", style: TextStyle(fontSize: 12, fontFamily: 'Muli')),
                                          Currency(
                                            value: double.parse(pesanan['grand_total'].toString()), // 🔥 Format harga ke currency
                                            style: const TextStyle(fontSize: 12, fontFamily: 'Muli', color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Text("Jumlah: ${produk['jumlah']}",
                                          style: const TextStyle(fontSize: 12, fontFamily: 'Muli')),
                                    ] else
                                      const Text("Produk tidak tersedia",
                                          style: TextStyle(fontSize: 12, fontFamily: 'Muli', color: Colors.red)),

                                    Text(
                                      "Ekspedisi: ${pesanan['ekspedisi'] ?? '-'}",
                                      style: const TextStyle(fontSize: 12, fontFamily: 'Muli'),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "No. Resi: ${pesanan['no_resi'] ?? '-'}",
                                          style: const TextStyle(fontSize: 12, fontFamily: 'Muli'),
                                        ),
                                        const SizedBox(width: 150),
                                        if (isPembayaranTab)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0),
                                          child: TextButton(
                                            onPressed:() {
                                              Navigator.push(
                                                context, 
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: UploadBuktiTransferScreen(pesananId: pesanan['id']) 
                                                )
                                              );
                                            }, 
                                            child: const Text(
                                              "Bayar",
                                              style: TextStyle(
                                                fontFamily: 'Muli',
                                                color: Colors.blue,
                                                fontSize: 12,
                                              ),
                                            )
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}