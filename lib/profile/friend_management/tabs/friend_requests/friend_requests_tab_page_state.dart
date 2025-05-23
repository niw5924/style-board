import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_board/models/friend_item.dart';

part 'friend_requests_tab_page_state.freezed.dart';

@freezed
class FriendRequestsTabPageState with _$FriendRequestsTabPageState {
  const factory FriendRequestsTabPageState({
    @Default(true) bool isLoading,
    @Default([]) List<FriendItem> friendRequests,
  }) = _FriendRequestsTabPageState;
}
