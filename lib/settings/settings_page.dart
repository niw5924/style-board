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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
          ),
          const SizedBox(height: 8),
          Text(
            user?.displayName ?? '사용자 이름',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              authProvider.logout();
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
