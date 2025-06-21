import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_account_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:flutter_naver_login/interface/types/naver_token.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final Uuid _uuid = const Uuid();

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

      await _firebaseAuth.signInWithCredential(credential);
      firebase_auth.User? user = _firebaseAuth.currentUser;

      if (user != null) {
        await _saveUserToFirestore(user);
        await _saveLoginMethod('google');
        debugPrint('Firebase Google 로그인 성공');
      }

      return user;
    } catch (e) {
      debugPrint('Google 로그인 실패: $e');
    }
    return null;
  }

  // Kakao 로그인 및 Firebase 연결
  Future<firebase_auth.User?> signInWithKakao() async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
        debugPrint('KakaoTalk 로그인 성공: ${token.accessToken}');
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        debugPrint('Kakao 계정 로그인 성공: ${token.accessToken}');
      }

      final userResponse = await UserApi.instance.me();
      final kakaoProfile = userResponse.kakaoAccount?.profile;
      final kakaoName = kakaoProfile?.nickname;
      final profileImageUrl = kakaoProfile?.profileImageUrl;

      final customToken =
          await FirebaseCustomTokenService.getFirebaseCustomToken(
        accessToken: token.accessToken,
        provider: 'kakao',
      );
      if (customToken == null) {
        debugPrint('Firebase Custom Token 요청 실패');
        return null;
      }

      await _firebaseAuth.signInWithCustomToken(customToken);
      firebase_auth.User? user = _firebaseAuth.currentUser;

      if (user != null) {
        await user.updateDisplayName(kakaoName);
        await user.updatePhotoURL(profileImageUrl);
        await user.reload(); // 서버에서 갱신된 사용자 정보를 다시 불러옵니다.
        user = _firebaseAuth.currentUser;
        await _saveUserToFirestore(user!);
        await _saveLoginMethod('kakao');
        debugPrint('Firebase Kakao 로그인 성공');
      }

      return user;
    } catch (e) {
      debugPrint('Kakao 로그인 실패: $e');
    }
    return null;
  }

  Future<firebase_auth.User?> signInWithNaver() async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status != NaverLoginStatus.loggedIn ||
          result.account == null) {
        debugPrint('Naver 로그인 실패 또는 취소');
        return null;
      }

      final NaverToken token = await FlutterNaverLogin.getCurrentAccessToken();
      if (!token.isValid()) {
        debugPrint('유효하지 않은 Naver accessToken');
        return null;
      }

      final String accessToken = token.accessToken;
      final NaverAccountResult account = result.account!;

      final customToken =
          await FirebaseCustomTokenService.getFirebaseCustomToken(
        accessToken: accessToken,
        provider: 'naver',
      );
      if (customToken == null) {
        debugPrint('Firebase Custom Token 요청 실패');
        return null;
      }

      await _firebaseAuth.signInWithCustomToken(customToken);
      firebase_auth.User? user = _firebaseAuth.currentUser;

      if (user != null) {
        await user.updateDisplayName(account.name);
        await user.updatePhotoURL(account.profileImage);
        await user.reload(); // 서버에서 갱신된 사용자 정보를 다시 불러옵니다.
        user = _firebaseAuth.currentUser;
        await _saveUserToFirestore(user!);
        await _saveLoginMethod('naver');
        debugPrint('Firebase Naver 로그인 성공');
      }

      return user;
    } catch (e) {
      debugPrint('Naver 로그인 예외 발생: $e');
      return null;
    }
  }

  // 로그인 방식 저장 (구글, 카카오, 네이버)
  Future<void> _saveLoginMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_method', method);
  }

  // 로그인 방식 불러오기
  Future<String?> getLoginMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('login_method');
  }

  // 로그인 방식 삭제 (로그아웃 시)
  Future<void> _clearLoginMethod() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_method');
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
      debugPrint('Firestore에 유저 정보 저장 성공');
    } catch (e) {
      debugPrint('Firestore에 유저 정보 저장 실패: $e');
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
      final loginMethod = await getLoginMethod();

      switch (loginMethod) {
        case 'google':
          await _googleSignIn.signOut();
          debugPrint('Google 로그아웃 성공');
          break;
        case 'kakao':
          await UserApi.instance.logout();
          debugPrint('Kakao 로그아웃 성공');
          break;
        case 'naver':
          await FlutterNaverLogin.logOut();
          debugPrint('Naver 로그아웃 성공');
          break;
      }

      await _firebaseAuth.signOut();
      await _clearLoginMethod();
      debugPrint('로그아웃 완료');
    } catch (e) {
      debugPrint('로그아웃 중 오류 발생: $e');
    }
  }

  // Firebase Storage 이미지, Firestore 사용자 문서, Firebase Auth 계정 삭제
  Future<void> deleteUserData() async {
    try {
      final user = _firebaseAuth.currentUser!;
      final userId = user.uid;
      final userRef = _firestore.collection('users').doc(userId);

      // Firebase Storage의 사용자 이미지 삭제
      final storageRef =
          FirebaseStorage.instance.ref().child('user_photos/$userId');
      final listResult = await storageRef.listAll();
      for (final item in listResult.items) {
        await item.delete();
        debugPrint('삭제된 이미지: ${item.fullPath}');
      }

      // Firestore의 하위 컬렉션 삭제
      final collections = [
        'photos',
        'myPicks',
        'friends',
        'friendRequestsSent',
        'friendRequestsReceived',
      ];
      for (var collection in collections) {
        final snapshot = await userRef.collection(collection).get();
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }

      // Firestore에서 사용자 문서 삭제
      await userRef.delete();
      debugPrint("Firestore 사용자 데이터 삭제 완료");

      // Firebase Authentication 계정 삭제
      await user.delete();
      debugPrint("Firebase Authentication 계정 삭제 완료");
    } catch (e) {
      debugPrint('사용자 데이터 삭제 실패: $e');
    }
  }

  // 회원탈퇴
  Future<void> withdraw() async {
    try {
      final loginMethod = await getLoginMethod();

      switch (loginMethod) {
        case 'google':
          await _googleSignIn.disconnect();
          debugPrint('Google 연결 해제 완료');
          break;
        case 'kakao':
          await UserApi.instance.unlink();
          debugPrint('Kakao 연결 해제 완료');
          break;
        case 'naver':
          await FlutterNaverLogin.logOutAndDeleteToken();
          debugPrint('Naver 연결 해제 완료');
          break;
      }

      await deleteUserData();
      await _firebaseAuth.signOut();
      await _clearLoginMethod();
      debugPrint('Firebase 로그아웃 완료');
      debugPrint('회원탈퇴 완료');
    } catch (e) {
      debugPrint('회원탈퇴 실패: $e');
    }
  }
}
