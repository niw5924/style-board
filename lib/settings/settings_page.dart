import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 프로필 이미지
          CircleAvatar(
            radius: 50, // 원형 아바타 크기
            backgroundImage: const AssetImage('assets/images/profile_placeholder.png'), // 임시 프로필 이미지
            backgroundColor: Colors.grey.shade300, // 배경색 (이미지가 없을 경우 대비)
          ),
          const SizedBox(height: 16), // 간격

          // 사용자 이름
          const Text(
            '사용자 이름', // 임시 사용자 이름
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8), // 간격

          // 상태 메시지 (선택 사항)
          const Text(
            '내 상태 메시지',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
