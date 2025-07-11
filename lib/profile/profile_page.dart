import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/main.dart';
import 'package:style_board/profile/body_info/body_info_dialog.dart';
import 'package:style_board/profile/friend_management/friend_management_page.dart';
import 'package:style_board/profile/my_picks/my_picks_page.dart';
import 'package:style_board/profile/profile_detail/profile_detail_page.dart';
import 'package:style_board/profile/weather/weather_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user?.uid;
    final userName = authProvider.user?.displayName;
    final userTag = authProvider.userTag;
    final userPhotoURL = authProvider.user?.photoURL;

    final userIdentifier = userName != null && userTag != null
        ? '$userName#$userTag'
        : userName ?? 'Unknown';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return const FractionallySizedBox(
                      heightFactor: 0.9,
                      child: ProfileDetailPage(),
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage:
                    userPhotoURL != null ? NetworkImage(userPhotoURL) : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userIdentifier,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            OptionCard(
              icon: Icons.info_outline,
              title: '신체정보',
              subtitle: '신체정보를 설정합니다.',
              onTap: () async {
                final result = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) => const BodyInfoDialog(),
                );
                if (result != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .set({'bodyInfo': result}, SetOptions(merge: true));

                  scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('신체정보가 성공적으로 저장되었습니다!')),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            OptionCard(
              icon: Icons.favorite_outline,
              title: '나의 Pick',
              subtitle: '내가 찜한 스타일들을 한눈에!',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyPicksPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            OptionCard(
              icon: Icons.style_outlined,
              title: '코디 추천',
              subtitle: '날씨에 따른 코디 추천을 확인합니다.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WeatherPage()),
                );
              },
            ),
            const SizedBox(height: 12),
            OptionCard(
              icon: Icons.person_add_alt_1_outlined,
              title: '친구 추가 및 관리',
              subtitle: '친구를 추가하고 옷장을 공유하세요.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FriendManagementPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(icon, color: Theme.of(context).colorScheme.surface),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
