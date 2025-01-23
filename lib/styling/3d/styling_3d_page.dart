import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:style_board/styling/category_tile.dart';

class Styling3DPage extends StatefulWidget {
  const Styling3DPage({super.key});

  @override
  _Styling3DPageState createState() => _Styling3DPageState();
}

class _Styling3DPageState extends State<Styling3DPage> {
  Map<String, dynamic>? _bodyInfo;

  Future<void> _applyBodyInfoToUnity() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user!.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        _bodyInfo = userDoc.data()?['bodyInfo'];

        if (_bodyInfo != null) {
          String gender = _bodyInfo!['gender'];
          double height = _bodyInfo!['height'].toDouble();
          double weight = _bodyInfo!['weight'].toDouble();

          // 성별에 따른 기준 값 설정
          double baseHeight = gender == '남성' ? 180 : 160;
          double baseWeight = gender == '남성' ? 75 : 60;

          // XZ 축 스케일: 몸무게
          double xzScale = weight / baseWeight;

          // Y 축 스케일: 키
          double yScale = height / baseHeight;

          // Unity로 스케일 값 전송
          sendToUnity(
            "Character", // Unity의 GameObject 이름
            "SetScale", // Unity에서 호출할 메서드 이름
            "$xzScale,$yScale,$xzScale", // X, Y, Z 축 스케일 전달
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('신체정보가 성공적으로 적용되었습니다!')),
          );
          print('Unity로 스케일 전송: XZ=$xzScale, Y=$yScale');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('신체정보가 없습니다. 먼저 신체정보를 설정하세요.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  void _showCategorySelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                '어떤 옷을 입혀볼까요?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final categories = ['상의', '하의', '아우터', '신발'];
                    final category = categories[index];

                    return CategoryTile(category: category);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: EmbedUnity(
            onMessageFromUnity: (String message) {
              print('Unity로부터 메시지 수신: $message');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _applyBodyInfoToUnity,
                child: const Text('신체정보 적용'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _showCategorySelectionSheet,
                child: const Text('옷장 열기'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
