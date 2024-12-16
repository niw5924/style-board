import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account != null) {
      print('Google 로그인 성공: ${account.email}');
    }
  }

  Future<void> signInWithKakao() async {
    if (await isKakaoTalkInstalled()) {
      try {
        var token = await UserApi.instance.loginWithKakaoTalk();
        print('Kakao 로그인 성공: ${token.accessToken}');
      } catch (e) {
        print('KakaoTalk 로그인 실패: $e');
      }
    } else {
      try {
        var token = await UserApi.instance.loginWithKakaoAccount();
        print('Kakao 로그인 성공: ${token.accessToken}');
      } catch (e) {
        print('Kakao 계정 로그인 실패: $e');
      }
    }
  }
}
