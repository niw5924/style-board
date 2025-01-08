import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_closet_page_state.freezed.dart';

@freezed
class FriendClosetPageState with _$FriendClosetPageState {
  const factory FriendClosetPageState({
    @Default(true) bool isLoading,
    @Default([]) List<String> friendPhotoPaths, // 친구 사진 경로 목록
    @Default([]) List<String> friendPhotoCategories, // 친구 사진 카테고리
    @Default([]) List<Map<String, String?>> friendPhotoTags, // 친구 사진 태그 정보
    @Default([]) List<bool> friendPhotoLikes, // 친구 사진 좋아요 상태
  }) = _FriendClosetPageState;
}
