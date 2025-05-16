import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/closet/closet_category_tag_popup.dart';
import 'package:style_board/closet/closet_filter_bottom_sheet.dart';
import 'package:style_board/closet/closet_page_cubit.dart';
import 'package:style_board/closet/closet_page_state.dart';
import 'package:style_board/closet/delete_photo_popup.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        final pickedXFile =
                            await context.read<ClosetPageCubit>().takePhoto();

                        if (pickedXFile != null) {
                          final result = await showDialog<Map<String, dynamic>>(
                            context: context,
                            builder: (_) => ClosetCategoryTagPopup(
                                pickedXFile: pickedXFile),
                          );

                          if (result != null) {
                            final category = result['category'] as String;
                            final tags =
                                Map<String, String>.from(result['tags']);
                            final isLiked = result['isLiked'] as bool;

                            await context
                                .read<ClosetPageCubit>()
                                .savePhotoWithDetails(
                                  pickedXFile: pickedXFile,
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
                        final pickedXFile = await context
                            .read<ClosetPageCubit>()
                            .pickPhotoFromGallery();

                        if (pickedXFile != null) {
                          final result = await showDialog<Map<String, dynamic>>(
                            context: context,
                            builder: (_) => ClosetCategoryTagPopup(
                                pickedXFile: pickedXFile),
                          );

                          if (result != null) {
                            final category = result['category'] as String;
                            final tags =
                                Map<String, String>.from(result['tags']);
                            final isLiked = result['isLiked'] as bool;

                            await context
                                .read<ClosetPageCubit>()
                                .savePhotoWithDetails(
                                  pickedXFile: pickedXFile,
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
                BlocBuilder<ClosetPageCubit, ClosetPageState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
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
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<ClosetPageCubit, ClosetPageState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final filteredItems =
                      context.read<ClosetPageCubit>().getFilteredClosetItems();

                  if (filteredItems.isEmpty) {
                    return const Center(
                      child: Text(
                        "필터링된 사진이 없습니다.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return AutoHeightGridView(
                    itemCount: filteredItems.length,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    padding: EdgeInsets.zero,
                    builder: (context, index) {
                      final item = filteredItems[index];

                      return Card(
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: Image.network(
                                    item.path,
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
                                      item.isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: item.isLiked
                                          ? Colors.red
                                          : Colors.black,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<ClosetPageCubit>()
                                          .togglePhotoLike(item);
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.category,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert),
                                        onSelected: (value) {
                                          if (value == 'delete') {
                                            showDialog(
                                              context: context,
                                              builder: (_) => DeletePhotoPopup(
                                                onConfirm: () {
                                                  context
                                                      .read<ClosetPageCubit>()
                                                      .deletePhoto(item);
                                                },
                                              ),
                                            );
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Text('삭제'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      _buildTag(item.tags['season']!),
                                      _buildTag(item.tags['color']!),
                                      _buildTag(item.tags['style']!),
                                      _buildTag(item.tags['purpose']!),
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
