import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/closet/closet_category_tag_popup.dart';
import 'package:style_board/closet/closet_filter_bottom_sheet.dart';
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
            child: Column(
              children: [
                Row(
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
                            final category =
                                categoryTagData['category'] as String;
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
                            final category =
                                categoryTagData['category'] as String;
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
                const SizedBox(height: 16),
                BlocBuilder<ClosetPageCubit, ClosetPageState>(
                  builder: (context, state) {
                    final chips = [
                      if (state.filterCategory != null)
                        InputChip(
                          label: Text(state.filterCategory!),
                          onDeleted: () {
                            context
                                .read<ClosetPageCubit>()
                                .updateCategory(null);
                          },
                        ),
                      if (state.filterSeason != null)
                        InputChip(
                          label: Text(state.filterSeason!),
                          onDeleted: () {
                            context.read<ClosetPageCubit>().updateSeason(null);
                          },
                        ),
                      if (state.filterColor != null)
                        InputChip(
                          label: Text(state.filterColor!),
                          onDeleted: () {
                            context.read<ClosetPageCubit>().updateColor(null);
                          },
                        ),
                      if (state.filterStyle != null)
                        InputChip(
                          label: Text(state.filterStyle!),
                          onDeleted: () {
                            context.read<ClosetPageCubit>().updateStyle(null);
                          },
                        ),
                      if (state.filterPurpose != null)
                        InputChip(
                          label: Text(state.filterPurpose!),
                          onDeleted: () {
                            context.read<ClosetPageCubit>().updatePurpose(null);
                          },
                        ),
                    ];
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: chips,
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ClosetPageCubit, ClosetPageState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 사진 자체가 없는 경우
                if (state.photoPaths.isEmpty) {
                  return const Center(
                    child: Text(
                      "저장된 사진이 없습니다.",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // 필터링 결과가 없는 경우
                final filteredIndices =
                    context.read<ClosetPageCubit>().getFilteredPhotoIndices();
                if (filteredIndices.isEmpty) {
                  return const Center(
                    child: Text(
                      "필터링된 사진이 없습니다.",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // 필터링 결과가 있는 경우
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: filteredIndices.length,
                  itemBuilder: (context, index) {
                    final photoIndex = filteredIndices[index];
                    final category = state.photoCategories[photoIndex];
                    final tags = state.photoTags[photoIndex];

                    return Card(
                      elevation: 2,
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
                                  File(state.photoPaths[photoIndex]),
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: IconButton(
                                  icon: Icon(
                                    state.photoLikes[photoIndex]
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: state.photoLikes[photoIndex]
                                        ? Colors.red
                                        : Colors.black,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<ClosetPageCubit>()
                                        .togglePhotoLike(photoIndex);
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
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await closetFilterBottomSheet(context);
          if (result != null) {
            context.read<ClosetPageCubit>()
              ..updateCategory(result['filterCategory'] as String?)
              ..updateSeason(result['filterSeason'] as String?)
              ..updateColor(result['filterColor'] as String?)
              ..updateStyle(result['filterStyle'] as String?)
              ..updatePurpose(result['filterPurpose'] as String?);
          }
        },
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
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
