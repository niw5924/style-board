import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MakeHumanApi {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  Future<Map<String, dynamic>> fetchBodyInfo(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/get_body_info'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch body info: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
