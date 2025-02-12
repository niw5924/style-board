import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseCustomTokenService {
  // 백엔드 서버의 URL: 변경해야 함!
  static const String _serverUrl =
      'http://192.168.35.85:3000/api/firebase-custom-token';

  // Kakao Access Token을 백엔드로 보내 Firebase Custom Token을 받아오는 메서드
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
