import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/utils/overlay_loader.dart';
import 'package:style_board/widgets/confirm_dialog.dart';
import 'profile_detail_page_cubit.dart';
import 'profile_detail_page_state.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({super.key});

  String _getTopTag(Map<String, int> tagCounts) {
    if (tagCounts.isEmpty) return '없음';
    final topTag =
        tagCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
    return topTag.key;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user!;
    final userId = user.uid;
    final displayName = user.displayName ?? 'Unknown';

    return BlocProvider(
      create: (_) => ProfileDetailPageCubit(userId)..loadProfileData(),
      child: BlocBuilder<ProfileDetailPageCubit, ProfileDetailPageState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final topSeason = _getTopTag(state.seasonTags);
          final topColor = _getTopTag(state.colorTags);
          final topStyle = _getTopTag(state.styleTags);
          final topPurpose = _getTopTag(state.purposeTags);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SectionBox(
                          title: '신체정보',
                          data: {
                            '성별': state.gender.isNotEmpty
                                ? state.gender
                                : '정보 없음',
                            '키': state.height > 0
                                ? '${state.height} cm'
                                : '정보 없음',
                            '몸무게': state.weight > 0
                                ? '${state.weight} kg'
                                : '정보 없음',
                          },
                        ),
                        const SizedBox(height: 16),
                        SectionBox(
                          title: '카테고리',
                          data: {
                            '상의': '${state.category['상의'] ?? 0}개',
                            '하의': '${state.category['하의'] ?? 0}개',
                            '아우터': '${state.category['아우터'] ?? 0}개',
                            '신발': '${state.category['신발'] ?? 0}개',
                          },
                        ),
                        const SizedBox(height: 16),
                        SectionBox(
                          title: '최다 태그',
                          data: {
                            '계절':
                                '$topSeason (${state.seasonTags[topSeason] ?? 0})',
                            '색상':
                                '$topColor (${state.colorTags[topColor] ?? 0})',
                            '스타일':
                                '$topStyle (${state.styleTags[topStyle] ?? 0})',
                            '용도':
                                '$topPurpose (${state.purposeTags[topPurpose] ?? 0})',
                          },
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => const ConfirmDialog(
                                icon: Icons.warning_rounded,
                                title: '옷장 초기화',
                                message: '정말로 옷장을 초기화하시겠습니까?\n저장된 모든 옷이 삭제됩니다.',
                                cancelText: '취소',
                                confirmText: '확인',
                              ),
                            );
                            if (confirmed == true) {
                              await context
                                  .read<ProfileDetailPageCubit>()
                                  .resetCloset();
                            }
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
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => const ConfirmDialog(
                                icon: Icons.logout,
                                title: '로그아웃',
                                message: '정말로 로그아웃하시겠습니까?',
                                cancelText: '취소',
                                confirmText: '확인',
                              ),
                            );
                            if (confirmed == true) {
                              OverlayLoader.show(context);
                              await context.read<AuthProvider>().logout();
                              OverlayLoader.hide();
                            }
                          },
                          child: const Text(
                            '로그아웃',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => const ConfirmDialog(
                                icon: Icons.warning_rounded,
                                title: '탈퇴하기',
                                message:
                                    '정말로 회원 탈퇴를 진행하시겠습니까?\n모든 데이터가 영구 삭제됩니다.',
                                cancelText: '취소',
                                confirmText: '확인',
                              ),
                            );
                            if (confirmed == true) {
                              OverlayLoader.show(context);
                              await context.read<AuthProvider>().withdraw();
                              OverlayLoader.hide();
                            }
                          },
                          child: Text(
                            '탈퇴하기',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SectionBox extends StatelessWidget {
  final String title;
  final Map<String, String> data;

  const SectionBox({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
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
