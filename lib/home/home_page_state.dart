import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_state.freezed.dart';

@freezed
class HomePageState with _$HomePageState {
  const factory HomePageState({
    @Default(0) int selectedIndex, // 선택된 탭의 인덱스
  }) = _HomePageState;
}
