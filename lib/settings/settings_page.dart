import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firebase_auth.User? user = authProvider.user;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 프로필 이미지 (있으면 네트워크 이미지, 없으면 배경색)
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
          ),
          const SizedBox(height: 16),
          // 사용자 이름
          Text(
            user?.displayName ?? '사용자 이름',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // 로그아웃 버튼
          ElevatedButton(
            onPressed: () {
              authProvider.logout();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '로그아웃',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
