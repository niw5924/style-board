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
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Firestore에서 bodyInfo 데이터 가져오기
      final userDocument = await userRef.get();
      final bodyInfo =
          userDocument.data()?['bodyInfo'] as Map<String, dynamic>?;

      final gender = bodyInfo?['gender'] as String? ?? '';
      final height = bodyInfo?['height'] as int? ?? 0;
      final weight = bodyInfo?['weight'] as int? ?? 0;

      // photos 컬렉션에서 옷 데이터 가져오기
      final photosSnapshot = await userRef.collection('photos').get();
      final clothingCount = photosSnapshot.docs.length;

      final Map<String, int> categoryCounts = {};
      final Map<String, int> seasonTagCounts = {};
      final Map<String, int> colorTagCounts = {};
      final Map<String, int> styleTagCounts = {};
      final Map<String, int> purposeTagCounts = {};

      for (var photo in photosSnapshot.docs) {
        final category = photo['category'] as String?;
        if (category != null) {
          categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
        }

        final tags = photo['tags'] as Map<String, dynamic>?;
        if (tags != null) {
          tags.forEach((key, value) {
            if (value is String) {
              switch (key) {
                case 'season':
                  seasonTagCounts[value] = (seasonTagCounts[value] ?? 0) + 1;
                  break;
                case 'color':
                  colorTagCounts[value] = (colorTagCounts[value] ?? 0) + 1;
                  break;
                case 'style':
                  styleTagCounts[value] = (styleTagCounts[value] ?? 0) + 1;
                  break;
                case 'purpose':
                  purposeTagCounts[value] = (purposeTagCounts[value] ?? 0) + 1;
                  break;
              }
            }
          });
        }
      }

      emit(state.copyWith(
        isLoading: false,
        gender: gender,
        height: height,
        weight: weight,
        clothingCount: clothingCount,
        category: categoryCounts,
        seasonTags: seasonTagCounts,
        colorTags: colorTagCounts,
        styleTags: styleTagCounts,
        purposeTags: purposeTagCounts,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print('Error loading profile data: $e');
    }
  }

  Future<void> resetCloset() async {
    emit(state.copyWith(isLoading: true));

    try {
      final userId = authProvider.user!.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('photos')
          .get();

      // 각 문서를 삭제
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      emit(state.copyWith(
        isLoading: false,
        clothingCount: 0,
        category: {},
        seasonTags: {},
        colorTags: {},
        styleTags: {},
        purposeTags: {},
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print('옷장 초기화 중 오류 발생: $e');
    }
  }
}
