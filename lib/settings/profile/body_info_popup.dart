import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';

class BodyInfoPopup extends StatefulWidget {
  const BodyInfoPopup({super.key});

  @override
  State<BodyInfoPopup> createState() => _BodyInfoPopupState();
}

class _BodyInfoPopupState extends State<BodyInfoPopup> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String? selectedGender;
  bool showError = false;

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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '신체정보 입력',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '성별 선택',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: genders
                    .map((gender) =>
                        DropdownMenuItem(value: gender, child: Text(gender)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '키 (cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '몸무게 (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (showError)
                Text(
                  '모든 정보를 입력해주세요.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 14,
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
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedGender != null &&
                          heightController.text.isNotEmpty &&
                          weightController.text.isNotEmpty) {
                        await saveBodyInfoToFirestore(userId);
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          showError = true;
                        });
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            showError = false;
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
      ),
    );
  }
}
