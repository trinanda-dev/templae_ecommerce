import 'package:http/http.dart' as http;
import 'dart:convert';

class DiscountBannerService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> getDiscountBanners() async {
    final response = await http.get(
      Uri.parse('$baseUrl/discount-banner'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load discount banners');
    }
  } 
}