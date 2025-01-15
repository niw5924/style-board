import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/styling/styling_page_cubit.dart';
import 'package:style_board/styling/styling_page_state.dart';

class StylingPage extends StatelessWidget {
  const StylingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CategoryTile(category: '상의'),
                  SizedBox(height: 20),
                  _CategoryTile(category: '하의'),
                  SizedBox(height: 20),
                  _CategoryTile(category: '신발'),
                ],
              ),
              SizedBox(width: 40),
              _CategoryTile(category: '아우터'),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingButtons(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // 플로팅 버튼 두 개 배치
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

    try {
      await cubit.addToMyPick();
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

class _CategoryTile extends StatelessWidget {
  final String category;

  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StylingPageCubit, StylingPageState>(
      builder: (context, state) {
        final representativePhoto = state.selectedPhotos[category];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showPhotoPicker(context, category),
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: representativePhoto != null
                    ? _buildImage(representativePhoto)
                    : Icon(
                        Icons.add_a_photo,
                        color: Theme.of(context).colorScheme.primary,
                        size: 40,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: path.startsWith('http://') || path.startsWith('https://')
          ? Image.network(path, fit: BoxFit.fill)
          : Image.file(File(path), fit: BoxFit.fill),
    );
  }

  void _showPhotoPicker(BuildContext context, String category) {
    final cubit = context.read<StylingPageCubit>();
    cubit.loadPhotosByCategory(category);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BlocBuilder<StylingPageCubit, StylingPageState>(
          builder: (context, state) {
            return FractionallySizedBox(
              heightFactor: 0.6,
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.isLoading)
                    const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                  else if (state.categoryPhotos.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.categoryPhotos.length,
                        itemBuilder: (context, index) {
                          final photo = state.categoryPhotos[index];
                          return GestureDetector(
                            onTap: () {
                              cubit.selectPhoto(category, photo);
                              Navigator.pop(context);
                            },
                            child: _buildImage(photo),
                          );
                        },
                      ),
                    )
                  else
                    const Expanded(child: Center(child: Text('저장된 사진이 없습니다.')))
                ],
              ),
            );
          },
        );
      },
    );
  }
}
