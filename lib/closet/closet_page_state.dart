import 'package:freezed_annotation/freezed_annotation.dart';

part 'closet_page_state.freezed.dart';

@freezed
class ClosetPageState with _$ClosetPageState {
  const factory ClosetPageState({
    @Default(true) bool isLoading,
    @Default([]) List<String> photoPaths, // 저장된 사진 경로 목록
    @Default([]) List<String> photoCategories, // 각 사진의 카테고리
    @Default([]) List<Map<String, String?>> photoTags, // 각 사진의 태그 정보
    @Default([]) List<bool> photoLikes, // 각 사진의 좋아요 상태
    @Default(null) String? filterCategory, // 선택된 카테고리 필터
    @Default(null) String? filterSeason, // 선택된 계절 필터
    @Default(null) String? filterColor, // 선택된 색상 필터
    @Default(null) String? filterStyle, // 선택된 스타일 필터
    @Default(null) String? filterPurpose, // 선택된 용도 필터
  }) = _ClosetPageState;
}
