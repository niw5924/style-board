import 'package:flutter/material.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // 사진 찍기 기능 구현 (Placeholder)
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('사진 찍기'),
              content: const Text('사진 찍기 기능은 여기에 구현됩니다.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('닫기'),
                ),
              ],
            ),
          );
        },
        child: const Text('사진 찍기 시작'),
      ),
    );
  }
}
