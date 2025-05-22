import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/widgets/validated_action_dialog.dart';

class FriendAddDialog extends StatefulWidget {
  const FriendAddDialog({super.key});

  @override
  State<FriendAddDialog> createState() => _FriendAddDialogState();
}

class _FriendAddDialogState extends State<FriendAddDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  Map<String, dynamic>? friendRequestPayload;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = auth.user!;
    final currentUserId = currentUser.uid;
    final currentUserName = currentUser.displayName!;
    final currentUserTag = auth.userTag!;
    final currentUserPhotoURL = currentUser.photoURL;

    return ValidatedActionDialog(
      icon: Icons.person_add,
      title: '친구 추가',
      confirmText: '추가',
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: '친구 이름',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: tagController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: '태그 (4자리)',
              prefixIcon: Icon(Icons.tag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      submitIfValid: () async {
        final name = nameController.text.trim();
        final tag = tagController.text.trim();

        if (name.isEmpty || tag.isEmpty) {
          return '이름과 태그를 모두 입력해주세요.';
        }

        if (tag.length != 4) {
          return '태그는 4자리 문자열로 입력해주세요.';
        }

        if (name == currentUserName && tag == currentUserTag) {
          return '자신에게 친구 요청을 보낼 수 없습니다.';
        }

        final receiverQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('userInfo.name', isEqualTo: name)
            .where('userInfo.tag', isEqualTo: tag)
            .get();

        if (receiverQuery.docs.isEmpty) {
          return '해당 태그의 사용자를 찾을 수 없습니다.';
        }

        final receiverDoc = receiverQuery.docs.first;
        final receiverId = receiverDoc.id;

        final isAlreadyFriend = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('friends')
            .doc(receiverId)
            .get();

        if (isAlreadyFriend.exists) {
          return '이미 친구로 등록된 사용자입니다.';
        }

        final isAlreadyRequested = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('friendRequestsSent')
            .doc(receiverId)
            .get();

        if (isAlreadyRequested.exists) {
          return '이미 친구 요청을 보냈습니다.';
        }

        friendRequestPayload = {
          'senderId': currentUserId,
          'receiverId': receiverId,
          'senderData': {
            'name': currentUserName,
            'photoURL': currentUserPhotoURL,
            'tag': currentUserTag,
          },
          'receiverData': {
            'name': receiverDoc['userInfo']['name'],
            'photoURL': receiverDoc['userInfo']['photoURL'],
            'tag': receiverDoc['userInfo']['tag'],
          },
        };

        return null;
      },
      onSuccessResult: () => friendRequestPayload,
    );
  }
}
