import 'package:flutter/material.dart';
import 'package:style_board/profile/friends/friend_service.dart';

class FriendAddPopup extends StatefulWidget {
  const FriendAddPopup({super.key});

  @override
  State<FriendAddPopup> createState() => _FriendAddPopupState();
}

class _FriendAddPopupState extends State<FriendAddPopup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  bool showError = false;
  String errorMessage = '';

  void _showError(String message) {
    setState(() {
      showError = true;
      errorMessage = message;
    });

    // 2초 후 에러 메시지 숨기기
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showError = false;
          errorMessage = '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add,
                    size: 24, color: Theme.of(context).colorScheme.onSurface),
                const SizedBox(width: 8),
                const Text(
                  '친구 추가',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '친구 이름',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tagController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: '태그 (4자리)',
                prefixIcon: const Icon(Icons.tag),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedOpacity(
              opacity: showError ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final tag = tagController.text.trim();

                    if (name.isEmpty || tag.isEmpty) {
                      _showError('이름과 태그를 모두 입력해주세요.');
                      return;
                    }

                    if (tag.length != 4) {
                      _showError('태그는 4자리 문자열로 입력해주세요.');
                      return;
                    }

                    final result = await FriendService.sendFriendRequest(
                        context, name, tag);

                    if (result != null) {
                      _showError(result);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('추가'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
