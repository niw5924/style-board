import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:style_board/auth/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void logout() async {
    try {
      // Firebase 인증 세션 및 계정 로그아웃
      await AuthService().signOut();

      // 사용자 상태 초기화
      _user = null;
      notifyListeners();
      print('로그아웃 성공 및 상태 초기화 완료');
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }
}
