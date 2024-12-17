import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_service.dart';
import 'package:style_board/auth/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();

  Future<void> _handleLogin(String loginType) async {
    switch (loginType) {
      case "Google":
        final user = await _authService.signInWithGoogle();
        if (user != null) {
          Provider.of<AuthProvider>(context, listen: false).setUser(user);
        }
        break;
      case "Kakao":
        final token = await _authService.signInWithKakao();
        if (token != null) {
          print('Kakao 로그인 성공: $token');
        }
        break;
      default:
        print("알 수 없는 로그인 타입: $loginType");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Center(
              child: Text(
                '스타일보드',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _handleLogin("Google"),
                  child: _buildLoginButton(
                    color: const Color(0xFFF05654),
                    iconPath: 'assets/images/google_icon.png',
                    text: 'Google 계정으로 로그인',
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _handleLogin("Kakao"),
                  child: _buildLoginButton(
                    color: const Color(0xFFFEE500),
                    iconPath: 'assets/images/kakao_icon.png',
                    text: '카카오 계정으로 로그인',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '본 서비스 로그인 시 이용약관 및 개인정보 처리방침에 동의한 것으로 간주됩니다.',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton({
    required Color color,
    required String iconPath,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
