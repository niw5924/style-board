import 'dart:io';
import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'friend_closet_page_cubit.dart';
import 'friend_closet_page_state.dart';

class FriendClosetPage extends StatefulWidget {
  final String friendId;
  final String friendName;
  final String friendTag;

  const FriendClosetPage({
    super.key,
    required this.friendId,
    required this.friendName,
    required this.friendTag,
  });

  @override
  State<FriendClosetPage> createState() => _FriendClosetPageState();
}

class _FriendClosetPageState extends State<FriendClosetPage> {
  @override
  void initState() {
    super.initState();
    context.read<FriendClosetPageCubit>().loadFriendCloset(widget.friendId);
  }

  @override
  Widget build(BuildContext context) {
    final title = '${widget.friendName}#${widget.friendTag}의 옷장';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<FriendClosetPageCubit, FriendClosetPageState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.friendPhotoPaths.isEmpty) {
            return const Center(
              child: Text(
                "친구의 옷장이 비어있습니다.",
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            return AutoHeightGridView(
              itemCount: state.friendPhotoPaths.length,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              padding: const EdgeInsets.all(16),
              builder: (context, index) {
                final category = state.friendPhotoCategories[index];
                final tags = state.friendPhotoTags[index];
                final isLiked = state.friendPhotoLikes[index];

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
                              File(state.friendPhotoPaths[index]),
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.black,
                              size: 24,
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
