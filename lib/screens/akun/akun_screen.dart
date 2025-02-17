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

  bool _isUpdating = false; // Untuk simulasi proses penyimpanan

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

  // Fungsi yang digunakan untuk memanggil provider update()
   // Fungsi untuk memanggil provider update()
  Future<void> _updatePengguna() async {
    // Pastikan form valid
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUpdating = true);

    final data = {
      'nama': _namaController.text,
      'nomor_hp': _nomorHpController.text,
      'nama_toko': _namaTokoController.text,
    };

    try {
      final penggunaProvider = Provider.of<PenggunaProvider>(context, listen: false);
      // Panggil update() dari provider
      await penggunaProvider.update(data);

      // Setelah update dilakukan, langsung ambil data baru
      await penggunaProvider.fetchPengguna();

      // Tampilkan pesan sukses
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: 
        Center(
          child: Text(
            "Data berhasil diperbarui",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Muli',
            ),
          ),
        )),
      );
    } catch (e) {
      // Tampilkan pesan error
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Center(
          child: Text(
            "Gagal menyimpan perubahan: $e",
            style: const  TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Muli',
            ),
          ),
        )),
      );
    } finally {
      setState(() => _isUpdating = false);
    }
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
                    style: const TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    controller: _namaController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 1.0,
                        )
                      ),
                      labelText: "Nama",
                      labelStyle: const TextStyle(
                        fontFamily: 'Muli',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey
                      ),
                      floatingLabelStyle: const TextStyle(
                        fontFamily: 'Muli',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.green
                      ),
                      border: const OutlineInputBorder(),
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
                    style: const TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    controller: _nomorHpController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 1.0,
                        )
                      ),
                      labelText: "Nomor Hp",
                      labelStyle: const TextStyle(
                        fontFamily: 'Muli',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey
                      ),
                      floatingLabelStyle: const TextStyle(
                        fontFamily: 'Muli',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.green
                      ),
                      border: const OutlineInputBorder(),
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
                    style: const TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    controller: _namaTokoController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 1.0,
                        )
                      ),
                      labelText: "Nama Toko",
                      labelStyle: const TextStyle(
                        fontFamily: 'Muli',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey
                      ),
                      floatingLabelStyle: const TextStyle(
                        fontFamily: 'Muli',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.green
                      ),
                      border: const OutlineInputBorder(),
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
                    onPressed: _isUpdating ? null: _updatePengguna,
                    child: _isUpdating
                        ? Lottie.asset(
                            'assets/lottie/loading-2.json',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                        )
                        : const Text(
                          "Simpan",
                          style: TextStyle(
                            fontFamily: 'Muli',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          )
                        ),
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