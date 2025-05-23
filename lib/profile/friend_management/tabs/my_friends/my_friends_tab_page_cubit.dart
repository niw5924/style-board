import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/models/friend_item.dart';
import 'my_friends_tab_page_state.dart';

class MyFriendsTabPageCubit extends Cubit<MyFriendsTabPageState> {
  MyFriendsTabPageCubit() : super(const MyFriendsTabPageState());

  Future<void> loadFriends(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('friends')
          .orderBy('name')
          .orderBy('tag')
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

      emit(state.copyWith(friendItems: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint("Error loading friends: $e");
    }
  }

  Future<void> sendFriendRequest({
    required String senderId,
    required String receiverId,
    required Map<String, dynamic> senderData,
    required Map<String, dynamic> receiverData,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('friendRequestsSent')
          .doc(receiverId)
          .set({
        'name': receiverData['name'],
        'photoURL': receiverData['photoURL'],
        'tag': receiverData['tag'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('friendRequestsReceived')
          .doc(senderId)
          .set({
        'name': senderData['name'],
        'photoURL': senderData['photoURL'],
        'tag': senderData['tag'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error sending friend request: $e");
    }
  }

  Future<void> deleteFriend({
    required String userId,
    required String friendId,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(friendId)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(userId)
          .delete();

      final updatedList =
          state.friendItems.where((item) => item.id != friendId).toList();

      emit(state.copyWith(friendItems: updatedList, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint("Error deleting friend: $e");
    }
  }
}
