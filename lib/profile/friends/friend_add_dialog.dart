import 'package:flutter/material.dart';
import 'package:style_board/widgets/validated_action_dialog.dart';
import 'package:style_board/profile/friends/friend_service.dart';

class FriendAddDialog extends StatefulWidget {
  const FriendAddDialog({super.key});

  @override
  State<FriendAddDialog> createState() => _FriendAddDialogState();
}

class _FriendAddDialogState extends State<FriendAddDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

        final result =
            await FriendService.sendFriendRequest(context, name, tag);
        if (result != null) {
          return result;
        }

        return null;
      },
    );
  }
}
