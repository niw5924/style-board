import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/home/home_page_cubit.dart';
import 'package:style_board/home/home_page_state.dart';
import '../closet/closet_page.dart';
import '../photo/photo_page.dart';
import '../settings/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const ClosetPage();
      case 1:
        return const PhotoPage();
      case 2:
        return const SettingsPage();
      default:
        return const Center(child: Text('페이지를 찾을 수 없습니다.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomePageCubit>();

    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('스타일보드'),
          ),
          body: _getBody(state.selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (index) => homeCubit.changeTab(index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.accessibility), label: '코디'),
              BottomNavigationBarItem(icon: Icon(Icons.checkroom), label: '옷장'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
            ],
          ),
        );
      },
    );
  }
}
