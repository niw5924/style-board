import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:style_board/models/friend_item.dart';
import 'friend_requests_tab_page_state.dart';

class FriendRequestsTabPageCubit extends Cubit<FriendRequestsTabPageState> {
  FriendRequestsTabPageCubit() : super(const FriendRequestsTabPageState());

  Future<void> loadFriendRequests({required String userId}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('friendRequestsReceived')
          .orderBy('timestamp', descending: true)
          .get();

      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        return FriendItem(
          id: doc.id,
          name: data['name'],
          tag: data['tag'],
          photoURL: data['photoURL'],
        );
      }).toList();

      emit(state.copyWith(friendRequests: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('친구 요청 로딩 실패: $e');
    }
  }

  Future<void> acceptRequest({
    required String currentUserId,
    required FriendItem requester,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final requesterDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(requester.id)
          .get();

      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      final requesterData = requesterDoc.data()!;
      final currentUserData = currentUserDoc.data()!;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .doc(requester.id)
          .set({
        'name': requesterData['userInfo']['name'],
        'photoURL': requesterData['userInfo']['photoURL'],
        'tag': requesterData['userInfo']['tag'],
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(requester.id)
          .collection('friends')
          .doc(currentUserId)
          .set({
        'name': currentUserData['userInfo']['name'],
        'photoURL': currentUserData['userInfo']['photoURL'],
        'tag': currentUserData['userInfo']['tag'],
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friendRequestsReceived')
          .doc(requester.id)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(requester.id)
          .collection('friendRequestsSent')
          .doc(currentUserId)
          .delete();

      final updatedList =
          state.friendRequests.where((r) => r.id != requester.id).toList();

      emit(state.copyWith(friendRequests: updatedList, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('친구 요청 수락 실패: $e');
    }
  }

  Future<void> rejectRequest({
    required String currentUserId,
    required String requesterId,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friendRequestsReceived')
          .doc(requesterId)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(requesterId)
          .collection('friendRequestsSent')
          .doc(currentUserId)
          .delete();

      final updatedList =
          state.friendRequests.where((r) => r.id != requesterId).toList();

      emit(state.copyWith(friendRequests: updatedList, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('친구 요청 거절 실패: $e');
    }
  }
}
