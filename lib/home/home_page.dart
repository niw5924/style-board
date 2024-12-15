import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/home/home_page_state.dart';
import '../closet/closet_page.dart';
import '../photo/photo_page.dart';
import '../settings/settings_page.dart';
import 'home_page_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // 각 탭의 화면 구성
  Widget _getBody(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const ClosetPage();
      case 1:
        return const PhotoPage(); // 사진 찍기 탭
      case 2:
        return const SettingsPage();
      default:
        return const Center(child: Text('페이지를 찾을 수 없습니다.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        final homeCubit = context.read<HomePageCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Style Board'),
          ),
          body: _getBody(state.selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.checkroom), // 옷장 아이콘
                label: '옷장',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt), // 사진 찍기 아이콘
                label: '사진 찍기',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings), // 설정 아이콘
                label: '설정',
              ),
            ],
            currentIndex: state.selectedIndex,
            onTap: (index) => homeCubit.changeTab(index),
          ),
        );
      },
    );
  }
}
