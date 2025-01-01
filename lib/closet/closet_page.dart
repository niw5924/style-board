import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/closet/closet_category_tag_popup.dart';
import 'package:style_board/closet/closet_page_cubit.dart';
import 'package:style_board/closet/closet_page_state.dart';

class ClosetPage extends StatefulWidget {
  const ClosetPage({super.key});

  @override
  State<ClosetPage> createState() => _ClosetPageState();
}

class _ClosetPageState extends State<ClosetPage> {
  @override
  void initState() {
    super.initState();
    context.read<ClosetPageCubit>().loadUserPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    final pickedFile =
                        await context.read<ClosetPageCubit>().takePhoto();

                    if (pickedFile != null) {
                      final categoryTagData = await closetCategoryTagPopup(
                          context, File(pickedFile.path));

                      if (categoryTagData != null) {
                        final category = categoryTagData['category'] as String;
                        final tags =
                            categoryTagData['tags'] as Map<String, String?>;
                        final isLiked = categoryTagData['isLiked'] as bool;

                        await context
                            .read<ClosetPageCubit>()
                            .savePhotoWithDetails(
                              filePath: pickedFile.path,
                              category: category,
                              tags: tags,
                              isLiked: isLiked,
                            );
                      }
                    }
                  },
                  child: const Text('사진 찍기'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    final pickedFile = await context
                        .read<ClosetPageCubit>()
                        .pickPhotoFromGallery();

                    if (pickedFile != null) {
                      final categoryTagData = await closetCategoryTagPopup(
                          context, File(pickedFile.path));

                      if (categoryTagData != null) {
                        final category = categoryTagData['category'] as String;
                        final tags =
                            categoryTagData['tags'] as Map<String, String?>;
                        final isLiked = categoryTagData['isLiked'] as bool;

                        await context
                            .read<ClosetPageCubit>()
                            .savePhotoWithDetails(
                              filePath: pickedFile.path,
                              category: category,
                              tags: tags,
                              isLiked: isLiked,
                            );
                      }
                    }
                  },
                  child: const Text('갤러리에서 가져오기'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ClosetPageCubit, ClosetPageState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.photoPaths.isEmpty) {
                  return const Center(
                    child: Text(
                      "저장된 사진이 없습니다.",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: state.photoPaths.length,
                    itemBuilder: (context, index) {
                      final category = state.photoCategories[index];
                      final tags = state.photoTags[index];

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.file(
                                    File(state.photoPaths[index]),
                                    width: double.infinity,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: IconButton(
                                    icon: Icon(
                                      state.photoLikes[index]
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: state.photoLikes[index]
                                          ? Colors.red
                                          : Colors.black,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<ClosetPageCubit>()
                                          .togglePhotoLike(index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      _buildTag(tags['season'] ?? ''),
                                      _buildTag(tags['color'] ?? ''),
                                      _buildTag(tags['style'] ?? ''),
                                      _buildTag(tags['purpose'] ?? ''),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.surface,
          fontSize: 12,
        ),
      ),
    );
  }
}
