import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/home/home_page_cubit.dart';
import 'package:style_board/home/home_page_state.dart';
import '../styling/styling_page.dart';
import '../closet/closet_page.dart';
import '../profile/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const StylingPage();
      case 1:
        return const ClosetPage();
      case 2:
        return const ProfilePage();
      default:
        return const Center(child: Text('페이지를 찾을 수 없습니다.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('스타일보드'),
          ),
          body: _getBody(state.selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (index) => context.read<HomePageCubit>().changeTab(index),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.accessibility), label: '코디'),
              BottomNavigationBarItem(icon: Icon(Icons.checkroom), label: '옷장'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이'),
            ],
          ),
        );
      },
    );
  }
}
