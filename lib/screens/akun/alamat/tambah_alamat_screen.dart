import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/alamat/alamat_provider.dart';
import 'package:shop_app/provider/raja_ongkir_provider/raja_ongkir_provider.dart';
import 'package:shop_app/screens/akun/alamat/alamat_screen.dart';


class TambahAlamatScreen extends StatefulWidget{
  const TambahAlamatScreen({super.key});

  @override
  State<TambahAlamatScreen> createState() => _TambahAlamatScreenState();
  
}

class _TambahAlamatScreenState extends State<TambahAlamatScreen> {
  final _formKey = GlobalKey<FormState>();
  // final List<String?> errors = [];
  bool _isUtama = false;
  bool _isLoading = false;
  String? provinceId;
  String? provinceName;
  String? cityId;
  String? cityName;
  String? postalCode;
  String? address;

  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _alamatLengkapController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Panggil fetch provinsi sekali, agar user bisa memilih provinsi
    final rajaOngkirProvider = Provider.of<RajaOngkirProvider>(context, listen: false);
    rajaOngkirProvider.fetchProvinces();
  }

  void _showProvinceModal(BuildContext context, RajaOngkirProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8, // 70% dari tinggi layar
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title:  Text(
                  'Pilih Provinsi',
                  style: Theme.of(context).textTheme.bodyMedium, 
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.provinces.length,
                  itemBuilder: (context, index) {
                    final province = provider.provinces[index];
                    return ListTile(
                      title: Text(province['name']),
                      onTap: () {
                        setState(() {
                          provinceId = province['id'];
                          provinceName = province['name'];
                          _provinsiController.text = province['name'];
                          cityId = null; // Reset kota saat provinsi berubah
                          cityName = null;
                        });
                        // Kosongkan list kota terlebih dahulu
                        provider.clearCities();
                        // Ambil kota baru untuk provinsi yang dipilih
                        provider.fetchCities(province['id']);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          )
        );
        
      },
    );
  }

  void _showCityModal(BuildContext context, RajaOngkirProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8, // 70% dari tinggi layar
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: Text(
                  'Pilih Kota',   
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.cities.length,
                  itemBuilder: (context, index) {
                    final city = provider.cities[index];
                    return ListTile(
                      title: Text(city['name']),
                      onTap: () {
                        setState(() {
                          cityId = city['id'];
                          cityName = city['name'];
                          _kotaController.text = city['name'];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final alamatProvider = Provider.of<AlamatProvider>(context);
    final rajaOngkirProvider = Provider.of<RajaOngkirProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Tambah Alamat Baru',
        ),
        titleSpacing: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 24, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Label alamat
              TextFormField(
                controller: _provinsiController,
                readOnly: true,
                onTap: () => _showProvinceModal(
                  context, 
                  rajaOngkirProvider
                ),
                decoration: InputDecoration(
                  labelText: 'Provinsi',
                  labelStyle: const TextStyle(
                    fontFamily: 'Open Sauce One',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  hintText: 'Pilih provinsi',
                  hintStyle: const TextStyle(
                    fontFamily: 'Open Sauce One',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  floatingLabelStyle: const TextStyle(
                    fontFamily: 'Open Sauce One',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.green,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    )
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 1.0,
                    )
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama provinsi tidak boleh kosong';
                  }
                  return null;
                }
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kotaController,
                readOnly: true,
                onTap: () => _showCityModal(
                  context, 
                  rajaOngkirProvider
                ),
                decoration: InputDecoration(
                  labelText: 'Kota',
                  labelStyle: const TextStyle(
                    fontFamily: 'Open Sauce One',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  hintText: 'Pilih Kota',
                  hintStyle: const TextStyle(
                    fontFamily: 'Open Sauce One',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  floatingLabelStyle: const TextStyle(
                    fontFamily: 'Open Sauce One',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.green,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    )
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 1.0,
                    )
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kota tidak boleh kosong';
                  }
                  return null;
                }
              ),
              const SizedBox(height: 16),
              // Alamat lengkap
              TextFormField(
                style: const TextStyle(
                  fontFamily: 'Open Sauce One',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                cursorColor: Colors.green,
                cursorHeight: 1.0,
                controller: _alamatLengkapController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey, 
                      width: 1.0
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 1.0,
                    )
                  ),
                  labelText: 'Alamat Lengkap',
                  labelStyle: const TextStyle(
                    fontFamily: 'Open Sauce One',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey
                  ),
                  floatingLabelStyle: const TextStyle(
                    fontFamily: 'Open Sauce One',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.green
                  ),
                  hintText: 'Masukkan alamat lengkap',
                  hintStyle: const TextStyle(
                    fontFamily: 'Open Sauce One',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat lengkap tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              // Kode pos
              Row(
                children: [
                  // TextFormField untuk Kode Pos
                  Expanded(
                    flex: 1, // Mengambil setengah lebar layar
                    child: TextFormField(
                      style: const TextStyle(
                        fontFamily: 'Open Sauce One',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      cursorHeight: 1.0,
                      cursorColor: Colors.green,
                      controller: _kodePosController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.grey, 
                            width: 1.0
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 1.0,
                          ),
                        ),
                        labelText: 'Kode Pos',
                        labelStyle: const TextStyle(
                          fontFamily: 'Open Sauce One',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                        floatingLabelStyle: const TextStyle(
                          fontFamily: 'Open Sauce One',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.green,
                        ),
                        hintText: 'Masukkan kode pos',
                        hintStyle: const TextStyle(
                          fontFamily: 'Open Sauce One',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kode pos tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8), // Jarak antara TextFormField dan CheckboxListTile

                  // CheckboxListTile untuk Jadikan sebagai alamat utama
                  Expanded(
                    flex: 1, // Mengambil setengah lebar layar
                    child: CheckboxListTile(
                      value: _isUtama,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          _isUtama = value ?? false;
                        });
                      },
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      title: const Text(
                        'Alamat utama',
                        style: TextStyle(
                          fontFamily: 'Open Sauce One',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero, // Hapus padding bawaan
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              // Tombol simpan
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLoading ? Colors.grey : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _isLoading
                  ? null
                  : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      // Simpan data alamat ke provider
                      final data = {
                        'provinsi': _provinsiController.text,
                        'id_provinsi' : provinceId,
                        'kota': _kotaController.text,
                        'id_kota': cityId,
                        'alamat_lengkap': _alamatLengkapController.text,
                        'kode_pos': _kodePosController.text,
                        'is_utama': _isUtama ? 1 : 0,
                      };

                      await alamatProvider.addAlamatToko(data);
                      setState(() {
                        _isLoading = false;
                      });

                      // Arahkan ke layar alamat setelah proses loading selesai
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context, 
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: const AlamatScreen(), 
                        )
                      );
                    }
                  },                
                child: _isLoading
                  ? Lottie.asset(
                      'assets/lottie/loading-2.json',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                  )
                : const Text(
                  'Simpan',
                  style: TextStyle(
                    fontFamily: 'Open Sauce One',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
  }
}