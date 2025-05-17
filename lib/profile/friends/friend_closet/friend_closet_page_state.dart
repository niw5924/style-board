import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_board/closet/closet_item.dart';

part 'friend_closet_page_state.freezed.dart';

@freezed
class FriendClosetPageState with _$FriendClosetPageState {
  const factory FriendClosetPageState({
    @Default(true) bool isLoading,
    @Default([]) List<ClosetItem> friendClosetItems,
  }) = _FriendClosetPageState;
}
