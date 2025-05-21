import 'package:flutter/material.dart';
import 'package:style_board/widgets/validated_action_dialog.dart';

class AddMyPickDialog extends StatefulWidget {
  const AddMyPickDialog({super.key});

  @override
  State<AddMyPickDialog> createState() => _AddMyPickDialogState();
}

class _AddMyPickDialogState extends State<AddMyPickDialog> {
  final TextEditingController pickNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValidatedActionDialog(
      icon: Icons.bookmark_add,
      title: '나의 Pick 추가',
      confirmText: '저장',
      content: TextField(
        controller: pickNameController,
        decoration: InputDecoration(
          labelText: 'Pick의 별명을 지어주세요!',
          prefixIcon: const Icon(Icons.text_fields),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      submitIfValid: () async {
        final name = pickNameController.text.trim();
        if (name.isEmpty) {
          return '이름을 입력해주세요.';
        }
        return null;
      },
      onSuccessResult: () => pickNameController.text.trim(),
    );
  }
}
