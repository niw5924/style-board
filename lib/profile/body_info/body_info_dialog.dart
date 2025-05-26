import 'package:flutter/material.dart';
import 'package:style_board/widgets/validated_action_dialog.dart';

class BodyInfoDialog extends StatefulWidget {
  const BodyInfoDialog({super.key});

  @override
  State<BodyInfoDialog> createState() => _BodyInfoDialogState();
}

class _BodyInfoDialogState extends State<BodyInfoDialog> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String? selectedGender;

  final genders = ['남성', '여성'];

  @override
  Widget build(BuildContext context) {
    return ValidatedActionDialog(
      icon: Icons.info,
      title: '신체정보 입력',
      content: Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: '성별 선택',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: genders
                .map((gender) =>
                    DropdownMenuItem(value: gender, child: Text(gender)))
                .toList(),
            onChanged: (value) => setState(() => selectedGender = value),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '키 (cm)',
              prefixIcon: const Icon(Icons.height),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '몸무게 (kg)',
              prefixIcon: const Icon(Icons.monitor_weight),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
      confirmText: '저장',
      submitIfValid: () async {
        final heightStr = heightController.text.trim();
        final weightStr = weightController.text.trim();

        if (selectedGender == null || heightStr.isEmpty || weightStr.isEmpty) {
          return '모든 정보를 입력해주세요.';
        }

        final height = int.tryParse(heightStr);
        final weight = int.tryParse(weightStr);

        if (height == null || weight == null) {
          return '키와 몸무게는 숫자로 입력해주세요.';
        }

        if (height <= 0 || weight <= 0) {
          return '키와 몸무게는 0보다 큰 숫자를 입력해주세요.';
        }

        return null;
      },
      onSuccessResult: () {
        final height = int.parse(heightController.text.trim());
        final weight = int.parse(weightController.text.trim());

        return {
          'gender': selectedGender!,
          'height': height,
          'weight': weight,
        };
      },
    );
  }
}
