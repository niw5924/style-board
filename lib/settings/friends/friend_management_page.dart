import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/settings/friends/friend_add_popup.dart';
import 'package:style_board/settings/friends/friend_service.dart';

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('friends')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('친구 목록이 없습니다.'),
              const SizedBox(height: 12),
              _buildAddFriendButton(context),
            ],
          );
        }

        final friends = snapshot.data!.docs;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ...friends.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final friendName = data['name'];
                final friendTag = data['tag'];
                final friendPhotoURL = data['photoURL'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildFriendCard(
                    context,
                    friendName,
                    friendTag,
                    friendPhotoURL,
                  ),
                );
              }),
              _buildAddFriendButton(context),
            ],
          ),
        );
      },
    );
  }

  // 친구 요청 목록 탭
  Widget _buildFriendRequestsTab(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('friendRequestsReceived')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('받은 친구 요청이 없습니다.'));
        }

        final friendRequests = snapshot.data!.docs;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: friendRequests.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final requesterName = data['name'];
              final requesterTag = data['tag'];
              final requesterPhotoURL = data['photoURL'];
              final requesterId = doc.id;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildFriendRequestCard(
                  context,
                  requesterName,
                  requesterTag,
                  requesterPhotoURL,
                  requesterId,
                ),
              );
            }).toList(),
          ),
        );
      },
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
  Widget _buildFriendCard(BuildContext context, String friendName,
      String friendTag, String? friendPhotoURL) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage:
                  friendPhotoURL != null ? NetworkImage(friendPhotoURL) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '$friendName#$friendTag',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 친구 요청 카드 UI
  Widget _buildFriendRequestCard(
    BuildContext context,
    String requesterName,
    String requesterTag,
    String? requesterPhotoURL,
    String requesterId,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage: requesterPhotoURL != null
                  ? NetworkImage(requesterPhotoURL)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '$requesterName#$requesterTag',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await FriendService.acceptFriendRequest(context, requesterId);
              },
              icon: const Icon(Icons.check_circle_outline),
              color: Theme.of(context).colorScheme.primary,
              tooltip: '수락',
            ),
            IconButton(
              onPressed: () async {
                await FriendService.rejectFriendRequest(context, requesterId);
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
