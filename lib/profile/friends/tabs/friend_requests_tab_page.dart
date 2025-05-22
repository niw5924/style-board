import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/main.dart';
import '../friend_service.dart';

class FriendRequestsTabPage extends StatelessWidget {
  const FriendRequestsTabPage({super.key});

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
