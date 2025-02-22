import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider/auth_provider.dart';
import 'package:shop_app/provider/raja_ongkir_provider/raja_ongkir_provider.dart';
import 'package:shop_app/provider/signup_provider/signup_provider.dart';
import 'package:shop_app/provider/signup_user_informations/signup_user_information_provider.dart';
import 'package:shop_app/screens/signup_success/signup_success_screen..dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({super.key});

  @override
  State<CompleteProfileForm> createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? provinceId;
  String? provinceName;
  String? cityId;
  String? cityName;
  String? subDistrict;
  String? postalCode;
  String? address;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
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
                          cityId = null; // Reset kota saat provinsi berubah
                          cityName = null;
                        });
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
    // Mengumpulkan semua data yang dibutuhkan terlebih dahulu
    final rajaOngkirProvider = Provider.of<RajaOngkirProvider>(context);
    final signUpProvider = Provider.of<SignUpProvider>(context);
    final signupUserInfoProvider = Provider.of<SignupUserInformationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);


    return Form(
      key: _formKey,
      child: Column(
        children: [
          InkWell(
            onTap: () => _showProvinceModal(context, rajaOngkirProvider),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: "Provinsi",
                hintText: "Pilih Provinsi",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
              ),
              child: Text(provinceName ?? "Pilih Provinsi"),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: provinceId == null
                ? null
                : () => _showCityModal(context, rajaOngkirProvider),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: "Kota",
                hintText: "Pilih Kota",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
              ),
              child: Text(cityName ?? "Pilih Kota"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onSaved: (newValue) => subDistrict = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kSubdistrictNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kSubdistrictNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Kecamatan",
              hintText: "Masukkan kecamatan Anda",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => postalCode = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kpostalCodeNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kpostalCodeNullError);
                return "";
              } else if (!postalCodeValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidPostalCode);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Kode Pos",
              hintText: "Masukkan kode pos Anda",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onSaved: (newValue) => address = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kAddressNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kAddressNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Alamat",
              hintText: "Masukkan alamat Anda",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
            ),
          ),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: authProvider.isLoading
              ? null
              : () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // Kumpulkan semua data dari provider
                final invitationCode = signUpProvider.invitationCode;
                final email = signUpProvider.email;
                final password = signUpProvider.password;
                final name = signupUserInfoProvider.name;
                final storeName = signupUserInfoProvider.storeName;
                final phoneNumber = signupUserInfoProvider.phoneNumber;

                // Kirim data ke backend
                try {
                  await authProvider.signUp(
                    name!,
                    email!,
                    password!,
                    password,
                    invitationCode!,
                    storeName!,
                    phoneNumber!,
                    address!,
                    cityId!,
                    cityName!,
                    provinceId!,
                    subDistrict!,
                    provinceName!,
                    postalCode!,
                  );
                } catch (e) {
                  addError(
                    error: e.toString()
                  );
                }
                // Simpan data ke provider atau lakukan sesuatu dengan data yang telah diisi
                Navigator.pushNamed(context, SignupSuccessScreen.routeName);
              }
            },
            child: authProvider.isLoading
              ? SizedBox(
                height: 40,
                width: 40,
                child: Lottie.asset(
                  'assets/lottie/loading-2.json',
                  fit: BoxFit.cover,
                ),
              )
            : const Text("Selanjutnya"),
          ),
        ],
      ),
    );
  }
}