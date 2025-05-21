import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/main.dart';
import 'package:style_board/profile/friends/friend_add_dialog.dart';
import 'package:style_board/profile/friends/friend_closet/friend_closet_page.dart';
import 'package:style_board/profile/friends/friend_closet/friend_closet_page_cubit.dart';
import 'package:style_board/profile/friends/friend_service.dart';
import 'package:style_board/widgets/confirm_dialog.dart';

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
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: const TabBarView(
          children: [
            MyFriendsTab(),
            FriendRequestsTab(),
          ],
        ),
      ),
    );
  }
}

class MyFriendsTab extends StatelessWidget {
  const MyFriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).user!.uid;

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
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('친구 목록이 없습니다.', style: TextStyle(fontSize: 16)),
              SizedBox(height: 12),
              AddFriendButton(),
            ],
          );
        }

        final friends = snapshot.data!.docs;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ...friends.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FriendCard(
                    friendId: doc.id,
                    friendName: data['name'],
                    friendTag: data['tag'],
                    friendPhotoURL: data['photoURL'],
                  ),
                );
              }),
              const AddFriendButton(),
            ],
          ),
        );
      },
    );
  }
}

class FriendRequestsTab extends StatelessWidget {
  const FriendRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).user!.uid;

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
          return const Center(
            child: Text('받은 친구 요청이 없습니다.', style: TextStyle(fontSize: 16)),
          );
        }

        final requests = snapshot.data!.docs;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: requests.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FriendRequestCard(
                  requesterId: doc.id,
                  requesterName: data['name'],
                  requesterTag: data['tag'],
                  requesterPhotoURL: data['photoURL'],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class AddFriendButton extends StatelessWidget {
  const AddFriendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => const FriendAddDialog(),
        );

        if (confirmed == true) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(content: Text('친구 요청을 보냈습니다.')),
          );
        }
      },
      icon: Icon(Icons.person_add_alt_1,
          color: Theme.of(context).colorScheme.surface),
      label: const Text('친구 추가'),
    );
  }
}

class FriendCard extends StatelessWidget {
  final String friendId;
  final String friendName;
  final String friendTag;
  final String? friendPhotoURL;

  const FriendCard({
    super.key,
    required this.friendId,
    required this.friendName,
    required this.friendTag,
    required this.friendPhotoURL,
  });

  @override
  Widget build(BuildContext context) {
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
                  friendPhotoURL != null ? NetworkImage(friendPhotoURL!) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '$friendName#$friendTag',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => FriendClosetPageCubit(),
                      child: FriendClosetPage(
                        friendId: friendId,
                        friendName: friendName,
                        friendTag: friendTag,
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.visibility),
              tooltip: '옷장 보기',
            ),
            IconButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => const ConfirmDialog(
                    icon: Icons.warning_rounded,
                    title: '친구 삭제',
                    message: '정말로 친구를 삭제하시겠습니까?\n되돌릴 수 없습니다.',
                    cancelText: '취소',
                    confirmText: '확인',
                  ),
                );

                if (confirmed == true) {
                  await FriendService.deleteFriend(context, friendId);
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('친구가 삭제되었습니다.')),
                  );
                }
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

class FriendRequestCard extends StatelessWidget {
  final String requesterId;
  final String requesterName;
  final String requesterTag;
  final String? requesterPhotoURL;

  const FriendRequestCard({
    super.key,
    required this.requesterId,
    required this.requesterName,
    required this.requesterTag,
    required this.requesterPhotoURL,
  });

  @override
  Widget build(BuildContext context) {
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
                  ? NetworkImage(requesterPhotoURL!)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '$requesterName#$requesterTag',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: () async {
                await FriendService.acceptFriendRequest(context, requesterId);
                scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(content: Text('친구 요청을 수락했습니다.')),
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              color: Theme.of(context).colorScheme.primary,
              tooltip: '수락',
            ),
            IconButton(
              onPressed: () async {
                await FriendService.rejectFriendRequest(context, requesterId);
                scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(content: Text('친구 요청을 거절했습니다.')),
                );
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
