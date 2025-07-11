import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FirebaseCustomTokenService {
  static final String _serverUrl = dotenv.env['CUSTOM_TOKEN_API_URL']!;

  static Future<String?> getFirebaseCustomToken({
    required String accessToken,
    required String provider,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'provider': provider,
          'accessToken': accessToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['firebaseCustomToken'];
      } else {
        debugPrint('Custom Token API 호출 실패: ${response.body}');
      }
    } catch (e) {
      debugPrint('Firebase Custom Token 가져오기 실패: $e');
    }
    return null;
  }
}
