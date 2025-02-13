import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseCustomTokenService {
  // Firebase Functions에서 배포된 실제 API URL 입력 (배포 후 확인 필요)
  static const String _serverUrl =
      'https://getfirebasecustomtoken-6rqnvjtpda-uc.a.run.app'; // 여기에 Firebase Functions API URL을 입력

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
