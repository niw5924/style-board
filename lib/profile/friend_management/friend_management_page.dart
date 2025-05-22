import 'package:flutter/material.dart';
import 'tabs/my_friends/my_friends_tab_page.dart';
import 'tabs/friend_requests/friend_requests_tab_page.dart';

class FriendManagementPage extends StatelessWidget {
  const FriendManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('친구 관리'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '내 친구 목록'),
              Tab(text: '친구 요청'),
            ],
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: const TabBarView(
          children: [
            MyFriendsTabPage(),
            FriendRequestsTabPage(),
          ],
        ),
      ),
    );
  }
}
