import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:style_board/auth/firebase_custom_token_service.dart';

class AuthService {
  // 싱글턴 인스턴스
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  String? _currentLoginMethod; // 로그인 방식 ('google' 또는 'kakao')

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
      final user = userCredential.user;

      print('Firebase Google 로그인 성공');
      _currentLoginMethod = 'google'; // 로그인 방식 저장
      return user;
    } catch (e) {
      print('Google 로그인 실패: $e');
    }
    return null;
  }

  // Kakao 로그인 및 Firebase 연결
  Future<firebase_auth.User?> signInWithKakao() async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
        print('KakaoTalk 로그인 성공: ${token.accessToken}');
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        print('Kakao 계정 로그인 성공: ${token.accessToken}');
      }

      final userResponse = await UserApi.instance.me();
      final kakaoProfile = userResponse.kakaoAccount?.profile;
      final kakaoName = kakaoProfile?.nickname;
      final profileImageUrl = kakaoProfile?.profileImageUrl;

      final customToken =
          await FirebaseCustomTokenService.getFirebaseCustomToken(
        token.accessToken,
      );
      if (customToken == null) {
        print('Firebase Custom Token 요청 실패');
        return null;
      }

      final userCredential =
          await _firebaseAuth.signInWithCustomToken(customToken);
      final user = userCredential.user;

      await user?.updateDisplayName(kakaoName);
      await user?.updatePhotoURL(profileImageUrl);

      print('Firebase Kakao 로그인 성공');
      _currentLoginMethod = 'kakao'; // 로그인 방식 저장
      return user;
    } catch (e) {
      print('Kakao 로그인 실패: $e');
    }
    return null;
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      switch (_currentLoginMethod) {
        case 'google':
          await _firebaseAuth.signOut();
          await _googleSignIn.signOut();
          print('Google 로그아웃 성공');
          break;

        case 'kakao':
          await _firebaseAuth.signOut();
          await UserApi.instance.logout();
          print('Kakao 로그아웃 성공');
          break;

        default:
          print('로그아웃 실패: 로그인된 사용자가 없습니다.');
      }
      _currentLoginMethod = null; // 로그인 방식 초기화
    } catch (e) {
      print('로그아웃 중 오류 발생: $e');
    }
  }
}
