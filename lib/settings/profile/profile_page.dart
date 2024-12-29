import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'closet_reset_dialog.dart';
import 'profile_page_cubit.dart';
import 'profile_page_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfilePageCubit>().loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePageCubit, ProfilePageState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // 각 태그 항목에서 가장 많이 선택된 태그 계산
        String topColor = _getTopTag(state.colorTags);
        String topSeason = _getTopTag(state.seasonTags);
        String topStyle = _getTopTag(state.styleTags);
        String topPurpose = _getTopTag(state.purposeTags);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // 사용자 이름
                Text(
                  context
                          .read<ProfilePageCubit>()
                          .authProvider
                          .user
                          ?.displayName ??
                      '사용자 이름 없음',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // 총 옷 개수
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.checkroom,
                      size: 28,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '총 ${state.clothingCount}개의 옷',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 신체정보 섹션
                _buildSectionBox(
                  title: '신체정보',
                  data: {
                    '성별': state.gender.isNotEmpty ? state.gender : '정보 없음',
                    '키': state.height > 0 ? '${state.height} cm' : '정보 없음',
                    '나이': state.age > 0 ? '${state.age}세' : '정보 없음',
                  },
                ),
                const SizedBox(height: 16),
                // 카테고리 섹션 (각 카테고리별 개수를 표시)
                _buildSectionBox(
                  title: '카테고리',
                  data: {
                    '상의': '${state.category['상의'] ?? 0}개',
                    '하의': '${state.category['하의'] ?? 0}개',
                    '아우터': '${state.category['아우터'] ?? 0}개',
                    '기타': '${state.category['기타'] ?? 0}개',
                  },
                ),
                const SizedBox(height: 16),
                // 최다 태그 섹션 (가장 많이 선택된 태그와 그 개수만 표시)
                _buildSectionBox(
                  title: '최다 태그',
                  data: {
                    '계절': '$topSeason (${state.seasonTags[topSeason] ?? 0})',
                    '색상': '$topColor (${state.colorTags[topColor] ?? 0})',
                    '스타일': '$topStyle (${state.styleTags[topStyle] ?? 0})',
                    '용도': '$topPurpose (${state.purposeTags[topPurpose] ?? 0})',
                  },
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ClosetResetDialog(
                        onConfirm: () {
                          context.read<ProfilePageCubit>().resetCloset();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    '옷장 초기화',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<ProfilePageCubit>().authProvider.logout();
                  },
                  child: const Text(
                    '로그아웃',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 가장 많이 선택된 태그를 반환하는 함수
  String _getTopTag(Map<String, int> tagCounts) {
    if (tagCounts.isEmpty) return '없음';
    final topTag =
        tagCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
    return topTag.key;
  }

  // 박스 형태로 데이터를 출력
  Widget _buildSectionBox({
    required String title,
    required Map<String, String> data,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: data.entries.map((entry) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      entry.value,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
