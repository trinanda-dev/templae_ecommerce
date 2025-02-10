import 'dart:convert';
import 'package:http/http.dart' as http;

class InvitationCodeService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final http.Client client;

  InvitationCodeService({required this.client});

  /// Validasi kode undangan sebelum lanjut ke tahap registrasi
  Future<bool> validateInvitationCode(String kodeUndangan) async {
    final response = await client.post(
      Uri.parse('$baseUrl/validate-invitation-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'kode_undangan': kodeUndangan}),
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 && result['status'] == 'success') {
      return true; // Kode undangan valid
    } else {
      throw Exception(result['message'] ?? 'Kode undangan tidak valid.');
    }
  }
}