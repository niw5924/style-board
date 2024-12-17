import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // 별칭 추가
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart'
    as kakao_user;

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  // Google 로그인 및 Firebase 연결
  Future<firebase_auth.User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      print('Firebase Google 로그인 성공: ${userCredential.user?.email}');
      return userCredential.user;
    } catch (e) {
      print('Google 로그인 실패: $e');
    }
    return null;
  }

  // Kakao 로그인
  Future<String?> signInWithKakao() async {
    try {
      if (await isKakaoTalkInstalled()) {
        var token = await UserApi.instance.loginWithKakaoTalk();
        print('KakaoTalk 로그인 성공: ${token.accessToken}');
        return token.accessToken;
      } else {
        var token = await UserApi.instance.loginWithKakaoAccount();
        print('Kakao 계정 로그인 성공: ${token.accessToken}');
        return token.accessToken;
      }
    } catch (e) {
      print('Kakao 로그인 실패: $e');
    }
    return null;
  }

  // 로그아웃
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
