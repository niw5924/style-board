import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_page_state.freezed.dart';

@freezed
class ProfilePageState with _$ProfilePageState {
  const factory ProfilePageState({
    @Default(true) bool isLoading,
    @Default('') String gender,
    @Default(0) int height,
    @Default(0) int weight,
    @Default(0) int clothingCount, // 총 옷 개수
    @Default({}) Map<String, int> category, // 카테고리 항목 (각 카테고리별 개수)
    @Default({}) Map<String, int> seasonTags, // season 태그
    @Default({}) Map<String, int> colorTags, // color 태그
    @Default({}) Map<String, int> styleTags, // style 태그
    @Default({}) Map<String, int> purposeTags, // purpose 태그
  }) = _ProfilePageState;
}
