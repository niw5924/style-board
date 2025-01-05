import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:style_board/auth/firebase_custom_token_service.dart';

class AuthService {
  // 싱글턴 인스턴스
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid(); // UUID 생성기
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

      if (user != null) {
        // Firestore에 유저 정보 저장
        await _saveUserToFirestore(user);
      }

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

      if (user != null) {
        // Firebase DisplayName과 PhotoURL 업데이트
        await user.updateDisplayName(kakaoName);
        await user.updatePhotoURL(profileImageUrl);

        // Firestore에 유저 정보 저장
        await _saveUserToFirestore(user);
      }

      print('Firebase Kakao 로그인 성공');
      _currentLoginMethod = 'kakao'; // 로그인 방식 저장
      return user;
    } catch (e) {
      print('Kakao 로그인 실패: $e');
    }
    return null;
  }

  // Firestore에 유저 정보 저장
  Future<void> _saveUserToFirestore(firebase_auth.User user) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);

      // Firestore에서 기존 데이터 확인
      final snapshot = await userDoc.get();
      String? existingTag = snapshot.data()?['userInfo']?['tag'];

      // 태그가 없다면 생성
      String userTag =
          existingTag ?? await _generateUniqueTag(user.displayName);

      // Firestore 문서에 userInfo 필드로 유저 정보 저장
      await userDoc.set({
        'userInfo': {
          'name': user.displayName, // 이름 저장 (null 허용)
          'tag': userTag, // 4자리 고유 태그
          'email': user.email, // 이메일 저장
          'photoURL': user.photoURL, // 프로필 사진 URL 저장
          'lastLoginAt': FieldValue.serverTimestamp(), // 마지막 로그인 시간
        },
      }, SetOptions(merge: true)); // 기존 필드 병합
      print('Firestore에 유저 정보 저장 성공');
    } catch (e) {
      print('Firestore에 유저 정보 저장 실패: $e');
    }
  }

  // Firestore에서 고유한 태그 생성
  Future<String> _generateUniqueTag(String? name) async {
    String tag;

    while (true) {
      // UUID의 앞 4자리 생성
      tag = _uuid.v4().substring(0, 4);

      // Firestore에서 동일한 이름 + 태그 존재 여부 확인
      final query = await _firestore
          .collection('users')
          .where('userInfo.name', isEqualTo: name)
          .where('userInfo.tag', isEqualTo: tag)
          .get();

      // 동일한 태그가 없으면 루프 종료
      if (query.docs.isEmpty) break;
    }

    return tag;
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
