import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/utils/overlay_loader.dart';

class AccountDeletionPopup extends StatelessWidget {
  const AccountDeletionPopup({super.key});

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
              '탈퇴하기',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '정말로 회원 탈퇴를 진행하시겠습니까?\n모든 데이터가 영구 삭제됩니다.',
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
                  onPressed: () async {
                    OverlayLoader.show(context);
                    await context.read<AuthProvider>().deleteAccount();
                    OverlayLoader.hide();
                    if (context.mounted) Navigator.pop(context);
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
