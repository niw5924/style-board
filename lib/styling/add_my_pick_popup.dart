import 'package:flutter/material.dart';

class AddMyPickPopup extends StatefulWidget {
  const AddMyPickPopup({super.key});

  @override
  State<AddMyPickPopup> createState() => _AddMyPickPopupState();
}

class _AddMyPickPopupState extends State<AddMyPickPopup> {
  final TextEditingController pickNameController = TextEditingController();
  bool showError = false;
  String errorMessage = '';

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
                Icon(Icons.bookmark_add,
                    size: 24, color: Theme.of(context).colorScheme.onSurface),
                const SizedBox(width: 8),
                const Text(
                  '나의 Pick 추가',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: pickNameController,
              decoration: InputDecoration(
                labelText: 'Pick의 별명을 지어주세요!',
                prefixIcon: const Icon(Icons.text_fields),
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
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('취소'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    final pickName = pickNameController.text.trim();

                    if (pickName.isEmpty) {
                      setState(() {
                        showError = true;
                        errorMessage = '이름을 입력해주세요.';
                      });
                    } else {
                      Navigator.pop(context, pickName);
                    }

                    if (showError) {
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          showError = false;
                          errorMessage = '';
                        });
                      });
                    }
                  },
                  child: const Text('저장'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
