import 'dart:io';
import 'package:auto_height_grid_view/auto_height_grid_view.dart';
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

  Future<void> _openFilterSheet(String section) async {
    final cubit = context.read<ClosetPageCubit>();
    final state = cubit.state;

    final result = await closetFilterBottomSheet(
      context,
      section: section,
      filterCategory: state.filterCategory,
      filterSeason: state.filterSeason,
      filterColor: state.filterColor,
      filterStyle: state.filterStyle,
      filterPurpose: state.filterPurpose,
    );

    if (result != null) {
      cubit
        ..updateCategory(result['filterCategory'] as String?)
        ..updateSeason(result['filterSeason'] as String?)
        ..updateColor(result['filterColor'] as String?)
        ..updateStyle(result['filterStyle'] as String?)
        ..updatePurpose(result['filterPurpose'] as String?);
    }
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
                    ElevatedButton.icon(
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
                                  imageFile: pickedFile,
                                  category: category,
                                  tags: tags,
                                  isLiked: isLiked,
                                );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('옷장에 새로운 아이템이 추가되었습니다!')),
                            );
                          }
                        }
                      },
                      icon: Icon(Icons.camera_alt,
                          color: Theme.of(context).colorScheme.surface),
                      label: const Text('사진 찍기'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
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
                                  imageFile: pickedFile,
                                  category: category,
                                  tags: tags,
                                  isLiked: isLiked,
                                );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('옷장에 새로운 아이템이 추가되었습니다!')),
                            );
                          }
                        }
                      },
                      icon: Icon(Icons.photo,
                          color: Theme.of(context).colorScheme.surface),
                      label: const Text('갤러리'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BlocBuilder<ClosetPageCubit, ClosetPageState>(
                  builder: (context, state) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (state.filterCategory != null)
                          InputChip(
                            label: Text(state.filterCategory!),
                            onDeleted: () => context
                                .read<ClosetPageCubit>()
                                .updateCategory(null),
                            onPressed: () => _openFilterSheet('카테고리'),
                          ),
                        if (state.filterSeason != null)
                          InputChip(
                            label: Text(state.filterSeason!),
                            onDeleted: () => context
                                .read<ClosetPageCubit>()
                                .updateSeason(null),
                            onPressed: () => _openFilterSheet('계절'),
                          ),
                        if (state.filterColor != null)
                          InputChip(
                            label: Text(state.filterColor!),
                            onDeleted: () => context
                                .read<ClosetPageCubit>()
                                .updateColor(null),
                            onPressed: () => _openFilterSheet('색상'),
                          ),
                        if (state.filterStyle != null)
                          InputChip(
                            label: Text(state.filterStyle!),
                            onDeleted: () => context
                                .read<ClosetPageCubit>()
                                .updateStyle(null),
                            onPressed: () => _openFilterSheet('스타일'),
                          ),
                        if (state.filterPurpose != null)
                          InputChip(
                            label: Text(state.filterPurpose!),
                            onDeleted: () => context
                                .read<ClosetPageCubit>()
                                .updatePurpose(null),
                            onPressed: () => _openFilterSheet('용도'),
                          ),
                      ],
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
                return AutoHeightGridView(
                  itemCount: filteredIndices.length,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  padding: const EdgeInsets.all(16),
                  builder: (context, index) {
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
                                child: Image.network(
                                  state.photoPaths[photoIndex],
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
        onPressed: () => _openFilterSheet('카테고리'),
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
