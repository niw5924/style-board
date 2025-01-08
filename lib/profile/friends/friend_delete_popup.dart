import 'package:flutter/material.dart';

class FriendDeletePopup extends StatelessWidget {
  final VoidCallback onConfirm;

  const FriendDeletePopup({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_rounded,
              size: 50,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 15),
            const Text(
              '친구 삭제',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '정말로 친구를 삭제하시겠습니까?\n되돌릴 수 없습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
