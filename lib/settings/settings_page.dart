import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '여기에 설정 관련 UI가 표시됩니다.',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
