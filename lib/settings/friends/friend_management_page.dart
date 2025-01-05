import 'package:flutter/material.dart';
import 'package:style_board/settings/friends/friend_add_popup.dart';

class FriendManagementPage extends StatelessWidget {
  const FriendManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('친구 관리'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '내 친구 목록'),
              Tab(text: '친구 요청'),
            ],
            labelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: TabBarView(
          children: [
            _buildMyFriendsTab(context),
            _buildFriendRequestsTab(context),
          ],
        ),
      ),
    );
  }

  // 내 친구 목록 탭
  Widget _buildMyFriendsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Column(
            children: List.generate(
              10, // 예제용 데이터 (친구 수)
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildFriendCard(context, '친구 ${index + 1}'),
              ),
            ),
          ),
          _buildAddFriendButton(context),
        ],
      ),
    );
  }

  // 친구 요청 목록 탭
  Widget _buildFriendRequestsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(
          10, // 예제용 데이터 (친구 요청 수)
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildFriendRequestCard(context, '요청자 ${index + 1}'),
          ),
        ),
      ),
    );
  }

  // 친구 추가 버튼
  Widget _buildAddFriendButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const FriendAddPopup(),
        );
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
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.person,
                  size: 30, color: Theme.of(context).colorScheme.surface),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                friendName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // 옷장 보기 기능 이후 구현
              },
              icon: const Icon(Icons.visibility),
              color: Theme.of(context).colorScheme.onSurface,
              tooltip: '옷장 보기',
            ),
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

  // 친구 요청 카드 UI
  Widget _buildFriendRequestCard(BuildContext context, String requesterName) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.person,
                  size: 30, color: Theme.of(context).colorScheme.surface),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                requesterName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // 친구 요청 수락 기능 이후 구현
              },
              icon: const Icon(Icons.check_circle_outline),
              color: Theme.of(context).colorScheme.primary,
              tooltip: '수락',
            ),
            IconButton(
              onPressed: () {
                // 친구 요청 거절 기능 이후 구현
              },
              icon: const Icon(Icons.cancel_outlined),
              color: Theme.of(context).colorScheme.error,
              tooltip: '거절',
            ),
          ],
        ),
      ),
    );
  }
}
