import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:style_board/auth/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _userTag;

  User? get user => _user;

  String? get userTag => _userTag;

  bool get isLoggedIn => _user != null;

  final AuthService _authService = AuthService();

  /// 앱 실행 시 로그인 상태 확인 후 기존 사용자 정보를 불러옴
  Future<void> checkLoginState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      debugPrint('이전 로그인 정보 확인됨: ${user.displayName} (UID: ${user.uid})');
      final loginMethod = await _authService.getLoginMethod();
      debugPrint('이전 로그인 방식: $loginMethod');
      await setUser(user);
    } else {
      debugPrint('로그인 정보 없음');
    }
  }

  /// 로그인한 사용자 정보를 설정
  Future<void> setUser(User? user) async {
    _user = user;
    _userTag = null;

    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data();
          if (data != null) {
            _userTag = data['userInfo']['tag'] as String?;
          }
        }
      } catch (e) {
        debugPrint('Firestore에서 태그를 가져오는 중 오류 발생: $e');
        _userTag = null;
      }

      debugPrint("로그인 성공");
      debugPrint(_user?.displayName);
      debugPrint(_user?.photoURL);
      debugPrint("태그: $_userTag");
    }

    notifyListeners();
  }

  /// Google 로그인 실행
  Future<void> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      await setUser(user);
      debugPrint("Google 로그인 완료");
    }
  }

  /// Kakao 로그인 실행
  Future<void> signInWithKakao() async {
    final user = await _authService.signInWithKakao();
    if (user != null) {
      await setUser(user);
      debugPrint("Kakao 로그인 완료");
    }
  }

  /// Naver 로그인 실행
  Future<void> signInWithNaver() async {
    final user = await _authService.signInWithNaver();
    if (user != null) {
      await setUser(user);
      debugPrint("Naver 로그인 완료");
    }
  }

  /// 로그아웃을 수행하고 상태를 초기화
  Future<void> logout() async {
    try {
      await _authService.signOut();
      debugPrint('로그아웃 성공 및 상태 초기화 완료');
      setUser(null);
    } catch (e) {
      debugPrint('로그아웃 실패: $e');
    }
  }

  /// 회원탈퇴 실행
  Future<void> withdraw() async {
    try {
      await _authService.withdraw();
      setUser(null);
      debugPrint('회원탈퇴 완료 및 상태 초기화');
    } catch (e) {
      debugPrint('회원탈퇴 오류: $e');
    }
  }
}
