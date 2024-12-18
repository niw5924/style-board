import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firebase_auth.User? user = authProvider.user; // Firebase User 가져오기

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 프로필 이미지 (있으면 네트워크 이미지, 없으면 배경색)
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!) // 프로필 이미지가 있을 때
                : null, // 이미지가 없을 때는 배경색만 표시
          ),
          const SizedBox(height: 16), // 간격

          // 사용자 이름
          Text(
            user?.displayName ?? '사용자 이름',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
