import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shop_app/helper/currency.dart';
import 'package:shop_app/screens/unggah_bukti_transfer/unggah_bukti_transfer_screen.dart';

class CheckoutWithOngkirCard extends StatelessWidget {
  final double totalHarga;
  final double ongkosKirim;
  final double grandTotal;
  final int pesananId;
  final String statusPesanan; // Tambahkan status pesanan

  const CheckoutWithOngkirCard({
    super.key,
    required this.totalHarga,
    required this.ongkosKirim,
    required this.grandTotal,
    required this.pesananId,
    required this.statusPesanan, // Terima status pesanan
  });

  @override
  Widget build(BuildContext context) {
    // Cek apakah pesanan masih dalam status "Menunggu Validasi Admin"
    bool isOngkirBelumDivalidasi = statusPesanan == "Menunggu Validasi Admin";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Harga Saat Checkout:",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Muli',
                ),
              ),
              Currency(
                value: totalHarga, 
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Muli',
                  color: Colors.black,
                )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ongkos Kirim:", 
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Muli',
                  color: Colors.black,
                )
              ),
              Currency(
                value: ongkosKirim, 
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Muli',
                  color: Colors.black,
                )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total:", 
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Muli',
                  color: Colors.black,
                )
              ),
              Currency(
                value: grandTotal, 
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Muli',
                  color: Colors.black,
                )
              ),
            ],
          ),
          const SizedBox(height: 14),
          
          // Tombol Lanjut ke Pembayaran
          ElevatedButton(
            onPressed: isOngkirBelumDivalidasi
                ? () { // Jika ongkir belum divalidasi, tampilkan snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Tunggu sebentar, kami sedang menghitung ongkos kirim Anda.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Muli',
                            fontSize: 14
                          ),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                : () { // Jika sudah divalidasi, navigasi ke unggah bukti transfer
                    Navigator.push(
                      context, 
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: UploadBuktiTransferScreen(
                          pesananId: pesananId,
                        ),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isOngkirBelumDivalidasi ? Colors.grey : Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text(
              "Lanjut ke Pembayaran",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Muli',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
