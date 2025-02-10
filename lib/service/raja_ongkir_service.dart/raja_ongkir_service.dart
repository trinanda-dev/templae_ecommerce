import 'dart:convert';
import 'package:http/http.dart' as http;

class RajaOngkirService {
  final String apiKey = "bd5fc864e456b6ed4b9d9c6604116184"; // Masukkan API Key dari RajaOngkir

  // Fungsi untuk mendapatkan daftar provinsi
  Future<List<Map<String, dynamic>>> getProvinces() async {
    final response = await http.get(
      Uri.parse("https://api.rajaongkir.com/starter/province"),
      headers: {"key": apiKey},
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List provinces = data['rajaongkir']['results'];
      return provinces
          .map((province) => {
                "id": province['province_id'],
                "name": province['province'],
              })
          .toList();
    } else {
      throw Exception("Failed to load provinces");
    }
  }

  // Fungsi untuk mendapatkan daftar kota berdasarkan ID provinsi
  Future<List<Map<String, dynamic>>> getCities(String provinceId) async {
    final response = await http.get(
      Uri.parse("https://api.rajaongkir.com/starter/city?province=$provinceId"),
      headers: {"key": apiKey},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List cities = data['rajaongkir']['results'];
      return cities
          .map((city) => {
                "id": city['city_id'],
                "name": city['city_name'],
              })
          .toList();
    } else {
      throw Exception("Failed to load cities");
    }
  }
}
