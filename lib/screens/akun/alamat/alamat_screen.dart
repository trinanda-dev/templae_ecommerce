import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/alamat/alamat_provider.dart';
import 'package:shop_app/screens/akun/alamat/tambah_alamat_screen.dart';
import 'package:shop_app/screens/init_screen.dart';

class AlamatScreen extends StatefulWidget {

  const AlamatScreen({
    super.key,
  });

  @override
  State<AlamatScreen> createState() => _AlamatScreenState();
}

  class _AlamatScreenState extends State<AlamatScreen> {

    @override
    void initState() {
      super.initState();
      // Panggil fetchAlamatToko saat pertama kali membuka halaman
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchAlamatToko();
      });
    }

    Future<void> _fetchAlamatToko() async {
      try {
        await Provider.of<AlamatProvider>(context, listen: false).fetchAlamatToko();
      } catch (e) {
        debugPrint("Gagal mengambil alamat: $e");
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Alamat Saya',
            style: TextStyle(
              fontFamily: 'Muli',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black
            )
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 20, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context, 
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const InitScreen() 
                )
              );
            },
          ),
        ),
        body: Consumer<AlamatProvider>(
          builder: (context, alamatProvider, child) {
            if (alamatProvider.isLoading) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Lottie.asset(
                    'assets/lottie/loading-2.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              );
            }
            if (alamatProvider.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  'Error: ${alamatProvider.errorMessage}',
                  style: const TextStyle(
                    fontFamily: 'Muli',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                            child: alamatProvider.alamatTokoList.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: alamatProvider.alamatTokoList.length,
                                    itemBuilder: (context, index) {
                                      final address = alamatProvider.alamatTokoList[index];
                                      return _buildAddressCard(address);
                                    },
                                  ),
                        )
                      ]
                    ),
                  )
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: const TambahAlamatScreen(), 
                          )
                        );
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                        maximumSize: const Size(double.infinity, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Tambah Alamat Baru',
                        style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ),
                  )
                )
              ],
            );
          }
        )
      );
    }

    // Widget untuk keadaan kosong
    Widget _buildEmptyState() {
      return Container(
        width: double.infinity, // Memastikan lebar penuh
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Posisi tengah vertikal
            children: [
              Lottie.asset(
                'assets/lottie/empty-address.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain, // Mengatur agar animasi sesuai
              ),
              const SizedBox(height: 16),
              const Text(
                'Belum ada alamat yang disimpan',
                style: TextStyle(
                  fontFamily: 'Muli',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silahkan tambahkan alamat baru.',
                style: TextStyle(
                  fontFamily: 'Muli',
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center, // Pusatkan teks
              ),
            ],
          ),
        ),
      );
    }

    // Widget untuk menampilkan alamat dalam bentuk kartu
    Widget _buildAddressCard(Map<String, dynamic> address) {
      final alamatProvier = Provider.of<AlamatProvider>(context, listen: false);
      


      return Dismissible(
        key: Key(address['id'].toString()),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          final addressCount = alamatProvier.alamatTokoList.length;
          final isMainAddress = address['is_utama'] == 1;

          debugPrint("Dikonfimasi hapus ID: ${address['id']}");

          if (direction == DismissDirection.endToStart) {
            // Cek jika adalah alamat utama
            if(isMainAddress) {
              return false;
            }
            // Geser ke kanan: Atur sebagai alamat utama
            return await showDialog(
              context: context, 
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Atur Alamat Utama',
                    style: TextStyle(
                      fontFamily: 'Muli',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Apakah Anda yakin ingin mengatur alamat ini sebagai alamat utama?',
                        style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text(
                              'Tidak',
                              style: TextStyle(
                                fontFamily: 'Muli',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: () {
                              // Panggil fungsi setUtamaAlamatToko dari provider
                              alamatProvier.setUtamaAlamatToko(address['id']);
                              Navigator.of(context).pop(true);
                            }, 
                            child: const Text(
                              'Ya',
                              style: TextStyle(
                                fontFamily: 'Muli',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            )
                          )
                        ],
                      )
                    ],
                  ),
                );
              }
            );
          } else if (direction == DismissDirection.startToEnd) {
            if (isMainAddress) {
              debugPrint("❌ Alamat utama tidak boleh dihapus.");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Alamat utama tidak dapat dihapus!"))
              );
              return false;
            }

            if (addressCount == 1) {
              debugPrint("❌ Tidak bisa menghapus karena hanya ada satu alamat.");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Minimal harus memiliki satu alamat."))
              );
              return false;
            }
            // Geser ke kiri: Hapus alamat
            return await showDialog(
              context: context, 
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Hapus Alamat',
                    style: TextStyle(
                      fontFamily: 'Muli',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center, // Pusatkan judul
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min, // Ukuran kolom sesuai dengan kontennya
                    children: [
                      const Text(
                        'Apakah Anda yakin ingin menghapus alamat ini?',
                        style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center, // Pusatkan teks
                      ),
                      const SizedBox(height: 20), // Tambahkan jarak antara teks dan tombol
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Pusatkan tombol
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                fontFamily: 'Muli',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16), // Jarak antara tombol
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              'Hapus',
                              style: TextStyle(
                                fontFamily: 'Muli',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            );
          }
          return false;
        },
        onDismissed: (direction) {
          debugPrint("Menghapus alamat dengan ID; ${address['id']}, Nama: ${address['pengguna']['nama']}, Nomor HP: ${address['pengguna']['nomor_hp']}");
          if (direction == DismissDirection.startToEnd) {
            // Hanya hapus jika swipe ke kiri
            alamatProvier.deleteAlamatToko(address['id']);
          }
        },
        background: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                // Background untuk geser ke kiri (startToEnd): Hapus
                Expanded(
                  child:  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16),
                    color: Colors.white,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Background untuk geser ke kanan (endToStart): Atur sebagai utama
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    color: Colors.white,
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  )
                )
              ],
            ),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 6,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama dan Nomor Telepon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    address['pengguna']['nama'] ?? '',
                    style: const TextStyle(
                      fontFamily: 'Muli',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    address['pengguna']['nomor_hp'] ?? '',
                    style: const TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Alamat Lengkap
              Text(
                address['alamat_lengkap'] ?? '',
                style: const TextStyle(
                  fontFamily: 'Muli',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                children: [
                  Text(
                    address['kota'] ?? '',
                    style: const TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 14,
                      color: Colors.black54,
                    )
                  ),
                  Text(
                    ', ${address['provinsi'] ?? ''}',
                    style: const TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    ', ${address['kecamatan'] ?? ''}',
                    style: const TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    ', ${address['kode_pos'] ?? ''}',
                    style: const TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 14,
                      color: Colors.black54,
                    )
                  )
                ],
              ),
              const SizedBox(height: 8),
              // Tag Alamat
              if (address.containsKey('is_utama') && address['is_utama'] == 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Alamat Utama',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
}