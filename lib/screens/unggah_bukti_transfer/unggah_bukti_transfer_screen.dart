import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/pesanan/pesanan_provider.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';

class UploadBuktiTransferScreen extends StatefulWidget {
  final int pesananId;

  const UploadBuktiTransferScreen({super.key, required this.pesananId});

  @override
  State<UploadBuktiTransferScreen> createState() => _UploadBuktiTransferScreenState();
}

class _UploadBuktiTransferScreenState extends State<UploadBuktiTransferScreen> {
  File? _selectedImage;

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pesananProvider = Provider.of<PesananProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran Transfer"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Bagian atas: Logo BCA & Nomor Rekening
            Column(
              children: [
                Image.asset(
                  'assets/images/logo-bca.png', // Ganti dengan path logo BCA
                  width: 100,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Nomor Rekening: 1234 5678 9012",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ Bagian tengah: Instruksi Pembayaran
            const Text(
              "Silahkan transfer sesuai jumlah yang diberikan dan unggah bukti transfernya di bawah ini",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Muli',
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),

            // ✅ Bagian bawah: Upload Bukti Transfer
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "Unggah Bukti Transfer",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'Muli',
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Indikator Loading
            if (pesananProvider.isUploading) Lottie.asset(
              'assets/lottie/loading-2.json',
              height: 100,
              width: 100,
            ),

            // ✅ Tampilkan Bukti Transfer yang Sudah Diupload
            if (pesananProvider.buktiTransferUrl != null)
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Bukti Transfer Berhasil Diupload!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Image.network(
                    pesananProvider.buktiTransferUrl!,
                    width: 200,
                  ),
                ],
              ),

            // ✅ Tampilkan pesan error jika ada
            if (pesananProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  pesananProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // ✅ Tombol Kirim
            ElevatedButton(
              onPressed: pesananProvider.isUploading
                  ? null
                  : () {
                      if (_selectedImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Silakan unggah bukti transfer terlebih dahulu")),
                        );
                      } else {
                        // Logging untuk memastikan file dikirim
                        debugPrint("Megirim file: ${_selectedImage!.path}");
                        pesananProvider.uploadBuktiTransfer(widget.pesananId, _selectedImage!);
                        Navigator.push(
                          context, 
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: const LoginSuccessScreen()
                          )
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                "Kirim",
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.white, 
                  fontFamily: 'Muli'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}