import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/closet_item.dart';

part 'closet_page_state.freezed.dart';

@freezed
class ClosetPageState with _$ClosetPageState {
  const factory ClosetPageState({
    @Default(true) bool isLoading,
    @Default([]) List<ClosetItem> closetItems,
    @Default(null) String? filterCategory,
    @Default(null) String? filterSeason,
    @Default(null) String? filterColor,
    @Default(null) String? filterStyle,
    @Default(null) String? filterPurpose,
  }) = _ClosetPageState;
}
