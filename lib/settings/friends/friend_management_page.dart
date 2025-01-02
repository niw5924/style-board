import 'package:flutter/material.dart';

class FriendManagementPage extends StatelessWidget {
  const FriendManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 관리'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 친구 리스트 섹션
            const Text(
              '내 친구 목록',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(
              children: List.generate(
                10, // 예제용 데이터 (친구 수)
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildFriendCard(context, '친구 ${index + 1}'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 친구 추가 버튼
            Center(child: _buildAddFriendButton(context)),
          ],
        ),
      ),
    );
  }

  // 친구 추가 버튼
  Widget _buildAddFriendButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // 친구 추가 기능 이후 구현
      },
      icon: Icon(Icons.person_add_alt_1,
          color: Theme.of(context).colorScheme.surface),
      label: const Text('친구 추가'),
    );
  }

  // 친구 카드 UI
  Widget _buildFriendCard(BuildContext context, String friendName) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            // 프로필 아이콘
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.person,
                  size: 30, color: Theme.of(context).colorScheme.surface),
            ),
            const SizedBox(width: 16),

            // 친구 이름 및 옵션
            Expanded(
              child: Text(
                friendName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 옷장 보기 버튼
            IconButton(
              onPressed: () {
                // 옷장 보기 기능 이후 구현
              },
              icon: const Icon(Icons.visibility),
              tooltip: '옷장 보기',
            ),

            // 삭제 버튼
            IconButton(
              onPressed: () {
                // 친구 삭제 기능 이후 구현
              },
              icon: const Icon(Icons.delete_outline),
              color: Theme.of(context).colorScheme.error,
              tooltip: '삭제',
            ),
          ],
        ),
      ),
    );
  }
}
