import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/widgets/tag_chip.dart';
import 'friend_closet_page_cubit.dart';
import 'friend_closet_page_state.dart';

class FriendClosetPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$friendName#$friendTag의 옷장',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (_) => FriendClosetPageCubit()..loadFriendCloset(friendId),
        child: BlocBuilder<FriendClosetPageCubit, FriendClosetPageState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.friendClosetItems.isEmpty) {
              return const Center(
                child: Text(
                  "친구의 옷장이 비어있습니다.",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return AutoHeightGridView(
              itemCount: state.friendClosetItems.length,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              padding: const EdgeInsets.all(16),
              builder: (context, index) {
                final item = state.friendClosetItems[index];

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
                              item.path,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Icon(
                              item.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: item.isLiked ? Colors.red : Colors.black,
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
                              item.category,
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
    );
  }
}
