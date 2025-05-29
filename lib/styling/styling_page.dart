import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/styling/2d/styling_2d_page.dart';
import 'package:style_board/styling/3d/styling_3d_page.dart';
import 'package:style_board/styling/add_my_pick_dialog.dart';
import 'package:style_board/styling/styling_page_cubit.dart';
import 'package:style_board/styling/styling_page_state.dart';
import 'package:style_board/main.dart';

class StylingPage extends StatelessWidget {
  const StylingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StylingPageCubit, StylingPageState>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    final isSelected = state.selectedTab == index;
                    final label = index == 0 ? '2D' : '3D';
                    return Padding(
                      padding: EdgeInsets.only(left: index == 1 ? 8.0 : 0),
                      child: GestureDetector(
                        onTap: () => context
                            .read<StylingPageCubit>()
                            .updateSelectedTab(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).colorScheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: state.selectedTab == 0
                        ? const Styling2DPage()
                        : const Styling3DPage(),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'resetButton',
                onPressed: () {
                  context.read<StylingPageCubit>().resetAllPhotos();
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('대표 사진이 초기화되었습니다.')),
                  );
                },
                tooltip: '대표 사진 초기화',
                child: const Icon(Icons.refresh),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'addPickButton',
                onPressed: () async {
                  final cubit = context.read<StylingPageCubit>();

                  if (!cubit.areAllCategoriesSelected()) {
                    scaffoldMessengerKey.currentState?.showSnackBar(
                      const SnackBar(content: Text('모든 카테고리를 선택해주세요!')),
                    );
                    return;
                  }

                  final result = await showDialog<String>(
                    context: context,
                    builder: (_) => const AddMyPickDialog(),
                  );

                  if (result != null) {
                    try {
                      await cubit.addToMyPickWithName(result);
                      scaffoldMessengerKey.currentState?.showSnackBar(
                        const SnackBar(
                            content: Text('현재 코디가 나의 Pick에 추가되었습니다!')),
                      );
                    } catch (e) {
                      scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
                tooltip: '나의 Pick 추가',
                child: const Icon(Icons.bookmark),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
