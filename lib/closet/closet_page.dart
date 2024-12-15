import 'package:flutter/material.dart';

class ClosetPage extends StatelessWidget {
  const ClosetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '여기에 옷장 관련 UI가 표시됩니다.',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
