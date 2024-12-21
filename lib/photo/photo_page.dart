import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/photo/photo_category_tag_popup.dart';
import 'photo_page_cubit.dart';
import 'photo_page_state.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  @override
  void initState() {
    super.initState();
    context.read<PhotoPageCubit>().loadUserPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 사진 찍기 버튼
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                HapticFeedback.mediumImpact();
                final pickedFile =
                    await context.read<PhotoPageCubit>().takePhoto();

                if (pickedFile != null) {
                  final categoryTagData = await showCategoryTagPopup(context);

                  if (categoryTagData != null) {
                    final category = categoryTagData['category'] as String;
                    final tags =
                        categoryTagData['tags'] as Map<String, String?>;

                    context.read<PhotoPageCubit>().savePhotoWithDetails(
                          filePath: pickedFile.path,
                          category: category,
                          tags: tags,
                        );
                  }
                }
              },
              child: const Text('사진 찍기'),
            ),
          ),
          // 사진 목록
          Expanded(
            child: BlocBuilder<PhotoPageCubit, PhotoPageState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.errorMessage != null) {
                  return Center(child: Text('오류: ${state.errorMessage}'));
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 한 줄에 두 개의 아이템
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 2 / 3,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.photoPaths.length,
                    itemBuilder: (context, index) {
                      final category = state.photoCategories[index];
                      final tags = state.photoTags[index];

                      return Column(
                        children: [
                          // 사진과 태그 (Stack)
                          Stack(
                            children: [
                              // 사진
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(state.photoPaths[index]),
                                ),
                              ),
                              // 왼쪽 위 (시즌)
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Chip(
                                  label: Text(tags['season']!),
                                  backgroundColor: Colors.green.shade100,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                ),
                              ),
                              // 오른쪽 위 (색깔)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Chip(
                                  label: Text(tags['color']!),
                                  backgroundColor: Colors.orange.shade100,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                ),
                              ),
                              // 왼쪽 아래 (스타일)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Chip(
                                  label: Text(tags['style']!),
                                  backgroundColor: Colors.purple.shade100,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                ),
                              ),
                              // 오른쪽 아래 (용도)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Chip(
                                  label: Text(tags['purpose']!),
                                  backgroundColor: Colors.red.shade100,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // 카테고리 텍스트
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
