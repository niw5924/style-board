import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_page_state.dart';
import 'package:style_board/auth/auth_provider.dart';

class ProfilePageCubit extends Cubit<ProfilePageState> {
  final AuthProvider authProvider;

  ProfilePageCubit(this.authProvider) : super(const ProfilePageState());

  Future<void> loadProfileData() async {
    emit(state.copyWith(isLoading: true));

    try {
      final userId = authProvider.user!.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('photos')
          .get();

      int clothingCount = snapshot.docs.length;

      // 카운트 초기화
      final Map<String, int> category = {}; // 카테고리 항목 (각 카테고리별 개수)
      final Map<String, int> seasonTags = {}; // season 태그
      final Map<String, int> colorTags = {}; // color 태그
      final Map<String, int> styleTags = {}; // style 태그
      final Map<String, int> purposeTags = {}; // purpose 태그

      // Firebase 데이터를 순회하며 카테고리와 태그 집계
      for (var doc in snapshot.docs) {
        // 카테고리 업데이트 (각 카테고리별 개수 증가)
        final categoryItem = doc['category'] as String?;
        if (categoryItem != null) {
          category[categoryItem] = (category[categoryItem] ?? 0) + 1;
        }

        // 태그 업데이트 (각 태그별 개수 증가)
        final tags = doc['tags'] as Map<String, dynamic>?;
        if (tags != null) {
          tags.forEach((key, value) {
            if (value is String) {
              switch (key) {
                case 'season':
                  seasonTags[value] = (seasonTags[value] ?? 0) + 1;
                  break;
                case 'color':
                  colorTags[value] = (colorTags[value] ?? 0) + 1;
                  break;
                case 'style':
                  styleTags[value] = (styleTags[value] ?? 0) + 1;
                  break;
                case 'purpose':
                  purposeTags[value] = (purposeTags[value] ?? 0) + 1;
                  break;
              }
            }
          });
        }
      }

      // 상태 업데이트
      emit(state.copyWith(
        isLoading: false,
        clothingCount: clothingCount,
        category: category,
        seasonTags: seasonTags,
        colorTags: colorTags,
        styleTags: styleTags,
        purposeTags: purposeTags,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print('Error loading profile data: $e');
    }
  }
}
