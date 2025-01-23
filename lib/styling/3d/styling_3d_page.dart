import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:style_board/styling/styling_page_cubit.dart';
import 'package:style_board/styling/styling_page_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StylingPageCubit, StylingPageState>(
      builder: (context, state) {
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
                    onPressed: () => {},
                    child: const Text('옷 가져오기'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
