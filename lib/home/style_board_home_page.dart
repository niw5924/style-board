import 'package:flutter/material.dart';
import '../closet/closet_page.dart';
import '../settings/settings_page.dart';

class StyleBoardHomePage extends StatefulWidget {
  const StyleBoardHomePage({super.key});

  @override
  State<StyleBoardHomePage> createState() => _StyleBoardHomePageState();
}

class _StyleBoardHomePageState extends State<StyleBoardHomePage> {
  int _selectedIndex = 0;

  // 탭 전환 시 호출되는 메서드
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 각 탭의 화면 구성
  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return const ClosetPage();
      case 1:
        return const SettingsPage();
      default:
        return const Center(child: Text('페이지를 찾을 수 없습니다.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Closet Styling'),
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom), // 옷장 아이콘
            label: '옷장',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // 설정 아이콘
            label: '설정',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
