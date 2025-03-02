import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/auth/account_deletion_popup.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/auth/logout_popup.dart';
import 'package:style_board/utils/overlay_loader.dart';
import 'closet_reset_popup.dart';
import 'profile_detail_page_cubit.dart';
import 'profile_detail_page_state.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileDetailPageCubit>().loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileDetailPageCubit, ProfileDetailPageState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        String topColor = _getTopTag(state.colorTags);
        String topSeason = _getTopTag(state.seasonTags);
        String topStyle = _getTopTag(state.styleTags);
        String topPurpose = _getTopTag(state.purposeTags);

        return Padding(
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
              Text(
                context
                        .read<ProfileDetailPageCubit>()
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
                      _buildSectionBox(
                        title: '신체정보',
                        data: {
                          '성별':
                              state.gender.isNotEmpty ? state.gender : '정보 없음',
                          '키':
                              state.height > 0 ? '${state.height} cm' : '정보 없음',
                          '몸무게':
                              state.weight > 0 ? '${state.weight} kg' : '정보 없음',
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSectionBox(
                        title: '카테고리',
                        data: {
                          '상의': '${state.category['상의'] ?? 0}개',
                          '하의': '${state.category['하의'] ?? 0}개',
                          '아우터': '${state.category['아우터'] ?? 0}개',
                          '신발': '${state.category['신발'] ?? 0}개',
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSectionBox(
                        title: '최다 태그',
                        data: {
                          '계절':
                              '$topSeason (${state.seasonTags[topSeason] ?? 0})',
                          '색상': '$topColor (${state.colorTags[topColor] ?? 0})',
                          '스타일':
                              '$topStyle (${state.styleTags[topStyle] ?? 0})',
                          '용도':
                              '$topPurpose (${state.purposeTags[topPurpose] ?? 0})',
                        },
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ClosetResetPopup(
                              onConfirm: () {
                                context
                                    .read<ProfileDetailPageCubit>()
                                    .resetCloset();
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
                          showDialog(
                            context: context,
                            builder: (context) => LogoutPopup(
                              onConfirm: () async {
                                OverlayLoader.show(context);
                                await context
                                    .read<ProfileDetailPageCubit>()
                                    .authProvider
                                    .logout();
                                OverlayLoader.hide();
                              },
                            ),
                          );
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AccountDeletionPopup(
                              onConfirm: () async {
                                OverlayLoader.show(context);
                                await context
                                    .read<AuthProvider>()
                                    .deleteAccount();
                                OverlayLoader.hide();
                              },
                            ),
                          );
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
    );
  }

  String _getTopTag(Map<String, int> tagCounts) {
    if (tagCounts.isEmpty) return '없음';
    final topTag =
        tagCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
    return topTag.key;
  }

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
