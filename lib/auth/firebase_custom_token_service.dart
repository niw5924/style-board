import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FirebaseCustomTokenService {
  static final String _serverUrl = dotenv.env['CUSTOM_TOKEN_API_URL']!;

  static Future<String?> getFirebaseCustomToken(String kakaoAccessToken) async {
    try {
      final response = await http.post(
        Uri.parse(_serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'kakaoAccessToken': kakaoAccessToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['firebaseCustomToken'];
      } else {
        print('Custom Token API 호출 실패: ${response.body}');
      }
    } catch (e) {
      print('Firebase Custom Token 가져오기 실패: $e');
    }
    return null;
  }
}
