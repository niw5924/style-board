import 'package:flutter/material.dart';
import 'package:style_board/widgets/common_popup_layout.dart';

class AddMyPickPopup extends StatefulWidget {
  const AddMyPickPopup({super.key});

  @override
  State<AddMyPickPopup> createState() => _AddMyPickPopupState();
}

class _AddMyPickPopupState extends State<AddMyPickPopup> {
  final TextEditingController pickNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CommonPopupLayout(
      icon: Icons.bookmark_add,
      title: '나의 Pick 추가',
      content: TextField(
        controller: pickNameController,
        decoration: InputDecoration(
          labelText: 'Pick의 별명을 지어주세요!',
          prefixIcon: const Icon(Icons.text_fields),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cancelText: '취소',
      confirmText: '저장',
      onCancel: () => Navigator.pop(context, null),
      onConfirm: () async {
        final pickName = pickNameController.text.trim();

        if (pickName.isEmpty) {
          return '이름을 입력해주세요.';
        }

        Navigator.pop(context, pickName);
        return null;
      },
    );
  }
}
