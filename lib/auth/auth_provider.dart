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

  // 앱 실행 시 로그인 상태 확인
  Future<void> checkLoginState() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print('이전 로그인 정보 확인됨: ${user.displayName} (UID: ${user.uid})');
      final loginMethod = await AuthService().getLoginMethod(); // 로그인 방식 불러오기
      print('이전 로그인 방식: $loginMethod');
      await setUser(user); // 기존 유저 정보 불러오기
    } else {
      print('로그인 정보 없음');
    }
  }

  Future<void> setUser(User? user) async {
    _user = user;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          _userTag = data['userInfo']['tag'] as String?;
        }
      }
    } catch (e) {
      print('Firestore에서 태그를 가져오는 중 오류 발생: $e');
      _userTag = null;
    }

    notifyListeners();
    print("로그인 성공");
    print(_user?.displayName);
    print(_user?.photoURL);
    print("태그: $_userTag");
  }

  // 로그아웃
  void logout() async {
    try {
      // Firebase 인증 세션 및 계정 로그아웃
      await AuthService().signOut();

      // 사용자 상태 초기화
      _user = null;
      _userTag = null;
      notifyListeners();
      print('로그아웃 성공 및 상태 초기화 완료');
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }
}
