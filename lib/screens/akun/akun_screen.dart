import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/pengguna/pengguna_provider.dart';

class EditProfileDataScreen extends StatefulWidget {
  const EditProfileDataScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileDataScreen> createState() => _EditProfileDataScreenState();
}

class _EditProfileDataScreenState extends State<EditProfileDataScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nomorHpController = TextEditingController();
  final TextEditingController _namaTokoController = TextEditingController();

  bool _isLoadingSave = false; // Untuk simulasi proses penyimpanan

  @override
  void initState() {
    super.initState();
    // Panggil fetchPengguna() saat layar dimulai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PenggunaProvider>(context, listen: false).fetchPengguna();
    });
  }

  // Metode ini akan dipanggil setelah data pengguna berhasil diambil
  // agar controller menampilkan data awal.
  void _setInitialData(Map<String, dynamic> userData) {
    _namaController.text = userData['nama'] ?? '';
    _nomorHpController.text = userData['nomor_hp'] ?? '';
    _namaTokoController.text = userData['nama_toko'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PenggunaProvider>(
        builder: (context, penggunaProvider, child) {
          if (penggunaProvider.isLoading) {
            return Center(
              child: Lottie.asset(
                'assets/lottie/loading-2.json',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            );
          }

          if (penggunaProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                'Error: ${penggunaProvider.errorMessage}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final userData = penggunaProvider.pengguna;
          if (userData == null) {
            return const Center(child: Text("Data pengguna tidak ditemukan."));
          }

          // Set data awal ke controller (hanya sekali saat pertama kali data valid)
          _setInitialData(userData);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Field Nama
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Field Nomor HP
                  TextFormField(
                    controller: _nomorHpController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Nomor HP",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor HP tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Field Nama Toko
                  TextFormField(
                    controller: _namaTokoController,
                    decoration: const InputDecoration(
                      labelText: "Nama Toko",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.store),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Toko tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tombol Save changes
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoadingSave
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoadingSave = true);

                              // Contoh: panggil method update user
                              // misalnya: await penggunaProvider.updatePengguna(...);
                              // Di sini kita hanya simulasi
                              await Future.delayed(const Duration(seconds: 2));

                              setState(() => _isLoadingSave = false);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Perubahan berhasil disimpan."),
                                ),
                              );
                            }
                          },
                    child: _isLoadingSave
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Save changes"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}