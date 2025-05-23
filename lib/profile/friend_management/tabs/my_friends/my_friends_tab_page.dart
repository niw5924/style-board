import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/main.dart';
import 'package:style_board/widgets/confirm_dialog.dart';
import 'package:style_board/profile/friend_management/tabs/my_friends/friend_add_dialog.dart';
import 'package:style_board/profile/friend_management/tabs/my_friends/friend_closet/friend_closet_page.dart';
import 'my_friends_tab_page_cubit.dart';
import 'my_friends_tab_page_state.dart';

class MyFriendsTabPage extends StatelessWidget {
  const MyFriendsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).user!.uid;

    return BlocProvider(
      create: (_) => MyFriendsTabPageCubit()..loadFriends(userId),
      child: BlocBuilder<MyFriendsTabPageCubit, MyFriendsTabPageState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.friendItems.isEmpty) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('친구 목록이 없습니다.', style: TextStyle(fontSize: 16)),
                SizedBox(height: 12),
                AddFriendButton(),
              ],
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.friendItems.length,
                  itemBuilder: (context, index) {
                    final friend = state.friendItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                backgroundImage: NetworkImage(friend.photoURL),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  '${friend.name}#${friend.tag}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                tooltip: '옷장 보기',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FriendClosetPage(
                                        friendId: friend.id,
                                        friendName: friend.name,
                                        friendTag: friend.tag,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: Theme.of(context).colorScheme.error,
                                tooltip: '삭제',
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => const ConfirmDialog(
                                      icon: Icons.warning_rounded,
                                      title: '친구 삭제',
                                      message: '정말로 친구를 삭제하시겠습니까?\n되돌릴 수 없습니다.',
                                      cancelText: '취소',
                                      confirmText: '확인',
                                    ),
                                  );

                                  if (confirmed == true) {
                                    await context
                                        .read<MyFriendsTabPageCubit>()
                                        .deleteFriend(
                                          userId: userId,
                                          friendId: friend.id,
                                        );
                                    scaffoldMessengerKey.currentState
                                        ?.showSnackBar(
                                      const SnackBar(
                                          content: Text('친구가 삭제되었습니다.')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const AddFriendButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AddFriendButton extends StatelessWidget {
  const AddFriendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final result = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => const FriendAddDialog(),
        );

        if (result != null) {
          await context.read<MyFriendsTabPageCubit>().sendFriendRequest(
                senderId: result['senderId'],
                receiverId: result['receiverId'],
                senderData: result['senderData'],
                receiverData: result['receiverData'],
              );
          scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(content: Text('친구 요청을 보냈습니다.')),
          );
        }
      },
      icon: Icon(Icons.person_add_alt_1,
          color: Theme.of(context).colorScheme.surface),
      label: const Text('친구 추가'),
    );
  }
}
