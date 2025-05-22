import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_board/models/friend_item.dart';

part 'my_friends_tab_page_state.freezed.dart';

@freezed
class MyFriendsTabPageState with _$MyFriendsTabPageState {
  const factory MyFriendsTabPageState({
    @Default(true) bool isLoading,
    @Default([]) List<FriendItem> friendItems,
  }) = _MyFriendsTabPageState;
}
