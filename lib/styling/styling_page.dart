import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/styling/2d/styling_2d_page.dart';
import 'package:style_board/styling/3d/styling_3d_page.dart';
import 'package:style_board/styling/add_my_pick_popup.dart';
import 'package:style_board/styling/styling_page_cubit.dart';

class StylingPage extends StatefulWidget {
  const StylingPage({super.key});

  @override
  _StylingPageState createState() => _StylingPageState();
}

class _StylingPageState extends State<StylingPage> {
  int _selectedMode = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildModeSelector(),
          Expanded(
            child: _selectedMode == 0
                ? const Styling2DPage()
                : const Styling3DPage(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingButtons(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildModeSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToggleButton(
            label: '2D',
            isSelected: _selectedMode == 0,
            onTap: () => setState(() => _selectedMode = 0),
          ),
          const SizedBox(width: 8),
          _buildToggleButton(
            label: '3D',
            isSelected: _selectedMode == 1,
            onTap: () => setState(() => _selectedMode = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  Widget _buildFloatingButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'resetButton',
          onPressed: () => _resetRepresentativePhotos(context),
          tooltip: '대표 사진 초기화',
          child: const Icon(Icons.refresh),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'addPickButton',
          onPressed: () => _addToMyPick(context),
          tooltip: '나의 Pick 추가',
          child: const Icon(Icons.bookmark),
        ),
      ],
    );
  }

  // 대표 사진 초기화 메소드
  void _resetRepresentativePhotos(BuildContext context) {
    final cubit = context.read<StylingPageCubit>();
    cubit.resetAllPhotos();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('대표 사진이 초기화되었습니다.')),
    );
  }

  // 나의 Pick 추가 메소드
  void _addToMyPick(BuildContext context) async {
    final cubit = context.read<StylingPageCubit>();

    if (!cubit.areAllCategoriesSelected()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 카테고리를 선택해주세요!')),
      );
      return;
    }

    // 모든 카테고리가 선택된 경우 팝업 띄우기
    final pickName = await showDialog<String>(
      context: context,
      builder: (_) => const AddMyPickPopup(),
    );

    if (pickName != null) {
      try {
        await cubit.addToMyPickWithName(pickName);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('현재 코디가 나의 Pick에 추가되었습니다!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
