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
  String errorMessage = '';

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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info,
                    size: 24, color: Theme.of(context).colorScheme.onSurface),
                const SizedBox(width: 8),
                const Text(
                  '신체정보 입력',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: '성별 선택',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: genders
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
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
              decoration: InputDecoration(
                labelText: '키 (cm)',
                prefixIcon: const Icon(Icons.height),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '몸무게 (kg)',
                prefixIcon: const Icon(Icons.monitor_weight),
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
                    final height =
                        int.tryParse(heightController.text.trim()) ?? 0;
                    final weight =
                        int.tryParse(weightController.text.trim()) ?? 0;

                    if (selectedGender == null ||
                        heightController.text.trim().isEmpty ||
                        weightController.text.trim().isEmpty) {
                      setState(() {
                        showError = true;
                        errorMessage = '모든 정보를 입력해주세요.';
                      });
                    } else if (height <= 0 || weight <= 0) {
                      setState(() {
                        showError = true;
                        errorMessage = '키와 몸무게는 0보다 큰 값을 입력해주세요.';
                      });
                    } else {
                      setState(() {
                        showError = false;
                        errorMessage = '';
                      });
                      await saveBodyInfoToFirestore(userId);
                      Navigator.pop(context, true);
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
