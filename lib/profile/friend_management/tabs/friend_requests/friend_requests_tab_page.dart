import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/main.dart';
import 'friend_requests_tab_page_cubit.dart';
import 'friend_requests_tab_page_state.dart';

class FriendRequestsTabPage extends StatelessWidget {
  const FriendRequestsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).user!.uid;

    return BlocProvider(
      create: (_) => FriendRequestsTabPageCubit()..loadFriendRequests(userId),
      child:
          BlocBuilder<FriendRequestsTabPageCubit, FriendRequestsTabPageState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.friendRequests.isEmpty) {
            return const Center(
              child: Text('받은 친구 요청이 없습니다.', style: TextStyle(fontSize: 16)),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.friendRequests.length,
                  itemBuilder: (context, index) {
                    final requester = state.friendRequests[index];
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
                                backgroundImage:
                                    NetworkImage(requester.photoURL),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  '${requester.name}#${requester.tag}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await context
                                      .read<FriendRequestsTabPageCubit>()
                                      .acceptRequest(
                                        currentUserId: userId,
                                        requester: requester,
                                      );
                                  scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                                    const SnackBar(
                                        content: Text('친구 요청을 수락했습니다.')),
                                  );
                                },
                                icon: const Icon(Icons.check_circle_outline),
                                color: Theme.of(context).colorScheme.primary,
                                tooltip: '수락',
                              ),
                              IconButton(
                                onPressed: () async {
                                  await context
                                      .read<FriendRequestsTabPageCubit>()
                                      .rejectRequest(
                                        currentUserId: userId,
                                        requesterId: requester.id,
                                      );
                                  scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                                    const SnackBar(
                                        content: Text('친구 요청을 거절했습니다.')),
                                  );
                                },
                                icon: const Icon(Icons.cancel_outlined),
                                color: Theme.of(context).colorScheme.error,
                                tooltip: '거절',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
