import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/models/closet_item.dart';
import 'friend_closet_page_state.dart';

class FriendClosetPageCubit extends Cubit<FriendClosetPageState> {
  FriendClosetPageCubit() : super(const FriendClosetPageState());

  Future<void> loadFriendCloset(String friendId) async {
    emit(state.copyWith(isLoading: true));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .collection('photos')
          .orderBy('timestamp', descending: false)
          .get();

      final items = snapshot.docs.map((doc) {
        return ClosetItem(
          path: doc['path'] as String,
          category: doc['category'] as String,
          tags: Map<String, String>.from(doc['tags'] as Map),
          isLiked: doc['isLiked'] as bool,
        );
      }).toList();

      emit(state.copyWith(friendClosetItems: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint("Error loading friend's closet: $e");
    }
  }
}
