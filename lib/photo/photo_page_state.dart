import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_page_state.freezed.dart';

@freezed
class PhotoPageState with _$PhotoPageState {
  const factory PhotoPageState({
    @Default(false) bool isLoading,
    @Default([]) List<String> photoPaths, // 저장된 사진 경로 목록
    @Default([]) List<String> photoCategories, // 각 사진의 카테고리
    @Default([]) List<Map<String, String?>> photoTags, // 각 사진의 태그 정보
  }) = _PhotoPageState;
}
