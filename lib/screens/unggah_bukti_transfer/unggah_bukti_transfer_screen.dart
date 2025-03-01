import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
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
  File? _compressedImage;

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File originalFile = File(pickedFile.path);

      // 🔥 Kompres gambar sebelum ditampilkan
      File? compressedFile = await _compressImage(originalFile);

      setState(() {
        _selectedImage = originalFile;
        _compressedImage = compressedFile;
      });
    }
  }

  // 🔥 **Fungsi untuk mengompres gambar**
  Future<File?> _compressImage(File file) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = "${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, 
      targetPath,
      quality: 70,  // 🔥 Sesuaikan kualitas (0 - 100)
    );

    return result != null ? File(result.path) : null;
  }

  @override
  Widget build(BuildContext context) {
    final pesananProvider = Provider.of<PesananProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "Pembayaran Transfer",
          style: Theme.of(context).textTheme.titleLarge 
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ **Bagian Informasi Rekening**
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFf5f5f5), Color(0xFFe0e0e0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo-bca.png',
                    width: 80,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Nomor Rekening",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "1234 5678 9012",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Silahkan transfer sesuai jumlah yang diberikan dan unggah bukti transfernya di bawah ini.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ **Bagian Upload Bukti Transfer**
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
                    ? Image.file(_compressedImage!, fit: BoxFit.cover)
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

            // ✅ **Indikator Loading saat Upload**
            if (pesananProvider.isUploading)
              Lottie.asset(
                'assets/lottie/loading-2.json',
                height: 100,
                width: 100,
              ),

            // ✅ **Tampilkan Bukti Transfer yang Sudah Diupload**
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

            // ✅ **Tampilkan pesan error jika ada**
            if (pesananProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  pesananProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 20),

            // ✅ **Tombol Kirim**
            ElevatedButton(
              onPressed: pesananProvider.isUploading
                  ? null
                  : () {
                      if (_compressedImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Silakan unggah bukti transfer terlebih dahulu")),
                        );
                      } else {
                        // 🔥 Kirim gambar yang sudah dikompresi
                        debugPrint("Mengirim file: ${_compressedImage!.path}");
                        pesananProvider.uploadBuktiTransfer(widget.pesananId, _compressedImage!);
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: const LoginSuccessScreen(),
                          ),
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
                  fontFamily: 'Muli',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
