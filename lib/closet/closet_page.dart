import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_board/closet/closet_category_tag_dialog.dart';
import 'package:style_board/closet/closet_filter_bottom_sheet.dart';
import 'package:style_board/closet/closet_page_cubit.dart';
import 'package:style_board/closet/closet_page_state.dart';
import 'package:style_board/main.dart';
import 'package:style_board/widgets/confirm_dialog.dart';
import 'package:style_board/widgets/tag_chip.dart';

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

  Future<void> _handlePickPhoto(ImageSource source) async {
    HapticFeedback.mediumImpact();

    final pickedXFile = await ImagePicker().pickImage(source: source);

    if (pickedXFile != null) {
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (_) => ClosetCategoryTagDialog(pickedXFile: pickedXFile),
      );

      if (result != null) {
        final category = result['category'] as String;
        final tags = Map<String, String>.from(result['tags'] as Map);
        final isLiked = result['isLiked'] as bool;

        await context.read<ClosetPageCubit>().savePhotoWithDetails(
          pickedXFile: pickedXFile,
          category: category,
          tags: tags,
          isLiked: isLiked,
        );

        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('새로운 사진이 옷장에 추가되었습니다!')),
        );
      }
    }
  }

  Future<void> _openFilterSheet(String section) async {
    final cubit = context.read<ClosetPageCubit>();
    final state = cubit.state;

    final result = await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ClosetFilterBottomSheet(
        section: section,
        filterCategory: state.filterCategory,
        filterSeason: state.filterSeason,
        filterColor: state.filterColor,
        filterStyle: state.filterStyle,
        filterPurpose: state.filterPurpose,
      ),
    );

    if (result != null) {
      cubit
        ..updateCategory(result['filterCategory'])
        ..updateSeason(result['filterSeason'])
        ..updateColor(result['filterColor'])
        ..updateStyle(result['filterStyle'])
        ..updatePurpose(result['filterPurpose']);
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
                      onPressed: () => _handlePickPhoto(ImageSource.camera),
                      icon: Icon(Icons.camera_alt,
                          color: Theme.of(context).colorScheme.surface),
                      label: const Text('사진 찍기'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => _handlePickPhoto(ImageSource.gallery),
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
                        "사진이 없습니다.",
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
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
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
                                        onSelected: (value) async {
                                          if (value == 'delete') {
                                            final confirmed =
                                            await showDialog<bool>(
                                              context: context,
                                              builder: (_) =>
                                              const ConfirmDialog(
                                                icon: Icons.warning_rounded,
                                                title: '사진 삭제',
                                                message:
                                                '정말로 이 사진을 삭제하시겠습니까?\n삭제된 사진은 복구할 수 없습니다.',
                                                cancelText: '취소',
                                                confirmText: '삭제',
                                              ),
                                            );

                                            if (confirmed == true) {
                                              await context
                                                  .read<ClosetPageCubit>()
                                                  .deletePhoto(item);

                                              scaffoldMessengerKey.currentState
                                                  ?.showSnackBar(
                                                const SnackBar(
                                                    content:
                                                    Text('사진이 삭제되었습니다.')),
                                              );
                                            }
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
                                      TagChip(text: item.tags['season']!),
                                      TagChip(text: item.tags['color']!),
                                      TagChip(text: item.tags['style']!),
                                      TagChip(text: item.tags['purpose']!),
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
}
