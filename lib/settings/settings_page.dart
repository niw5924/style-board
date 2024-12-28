import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/settings/profile/profile_page.dart';
import 'package:style_board/weather/weather_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.user?.displayName ?? '사용자 이름';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              _showProfileModal(context);
            },
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              backgroundImage: authProvider.user?.photoURL != null
                  ? NetworkImage(authProvider.user!.photoURL!)
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WeatherPage()),
              );
            },
            child: const Text(
              '코디 추천',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.9,
          child: ProfilePage(),
        );
      },
    );
  }
}
