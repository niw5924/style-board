import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/utils/overlay_loader.dart';

import '../widgets/typewriter_text.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Center(
              child: TypewriterText(
                text: '스타일보드',
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
                  onTap: () async {
                    OverlayLoader.show(context);
                    await authProvider.signInWithGoogle();
                    OverlayLoader.hide();
                  },
                  child: _buildLoginButton(
                    color: Colors.white,
                    iconPath: 'assets/images/google_logo.png',
                    text: 'Google 계정으로 로그인',
                    textColor: Colors.black.withValues(alpha: 0.54),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    OverlayLoader.show(context);
                    await authProvider.signInWithKakao();
                    OverlayLoader.hide();
                  },
                  child: _buildLoginButton(
                    color: const Color(0xFFFEE500),
                    iconPath: 'assets/images/kakao_logo.png',
                    text: '카카오 계정으로 로그인',
                    textColor: Colors.black.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    OverlayLoader.show(context);
                    await authProvider.signInWithNaver();
                    OverlayLoader.hide();
                  },
                  child: _buildLoginButton(
                    color: const Color(0xFF03C75A),
                    iconPath: 'assets/images/naver_logo.png',
                    text: '네이버 계정으로 로그인',
                    textColor: Colors.white,
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
    required Color textColor,
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
          Image.asset(iconPath, width: 18, height: 18),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
