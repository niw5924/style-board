import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
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

  Future<void> saveBodyInfoToFirestore(String userId) async {
    final bodyInfo = {
      'gender': selectedGender,
      'height': int.tryParse(heightController.text.trim()) ?? 0,
      'weight': int.tryParse(weightController.text.trim()) ?? 0,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'bodyInfo': bodyInfo}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user!.uid;

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
        final height = int.tryParse(heightStr) ?? 0;
        final weight = int.tryParse(weightStr) ?? 0;

        if (selectedGender == null || heightStr.isEmpty || weightStr.isEmpty) {
          return '모든 정보를 입력해주세요.';
        }

        if (height <= 0 || weight <= 0) {
          return '키와 몸무게는 0보다 큰 값을 입력해주세요.';
        }

        await saveBodyInfoToFirestore(userId);
        return null;
      },
    );
  }
}
