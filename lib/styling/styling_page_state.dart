import 'package:freezed_annotation/freezed_annotation.dart';

part 'styling_page_state.freezed.dart';

@freezed
class StylingPageState with _$StylingPageState {
  const factory StylingPageState({
    @Default(true) bool isLoading,
    @Default(null) String? selectedCategory, // 선택된 카테고리 이름
    @Default([]) List<String> categoryPhotos, // 선택된 카테고리의 모든 사진 목록
    @Default({}) Map<String, String> selectedPhotos, // 각 카테고리의 대표 사진
  }) = _StylingPageState;
}
