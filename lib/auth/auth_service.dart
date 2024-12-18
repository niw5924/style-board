import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:style_board/auth/firebase_custom_token_service.dart';

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
      print('Firebase Google 로그인 성공');
      return userCredential.user;
    } catch (e) {
      print('Google 로그인 실패: $e');
    }
    return null;
  }

  // Kakao 로그인 및 Firebase 연결
  Future<firebase_auth.User?> signInWithKakao() async {
    try {
      // Kakao 로그인 수행
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
        print('KakaoTalk 로그인 성공: ${token.accessToken}');
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        print('Kakao 계정 로그인 성공: ${token.accessToken}');
      }

      // Kakao 사용자 정보 가져오기
      final userResponse = await UserApi.instance.me();
      final kakaoProfile = userResponse.kakaoAccount?.profile;
      final kakaoName = kakaoProfile?.nickname ?? "사용자 이름";
      final profileImageUrl = kakaoProfile?.profileImageUrl;

      print('Kakao 사용자 이름: $kakaoName');
      print('Kakao 프로필 이미지: $profileImageUrl');

      // Firebase Custom Token 요청
      final customToken =
          await FirebaseCustomTokenService.getFirebaseCustomToken(
              token.accessToken);
      if (customToken == null) {
        print('Firebase Custom Token 요청 실패');
        return null;
      }

      // Firebase 로그인
      final userCredential =
          await _firebaseAuth.signInWithCustomToken(customToken);
      final user = userCredential.user;

      // Firebase 사용자 프로필 업데이트
      await user?.updateDisplayName(kakaoName);
      if (profileImageUrl != null) {
        await user?.updatePhotoURL(profileImageUrl);
      }

      print('Firebase Kakao 로그인 성공');
      return user;
    } catch (e) {
      print('Kakao 로그인 실패: $e');
    }
    return null;
  }

  // 로그아웃
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    print('로그아웃 성공');
  }
}
