import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

      final friendPhotoPaths =
          snapshot.docs.map((doc) => doc['path'] as String).toList();
      final friendPhotoCategories =
          snapshot.docs.map((doc) => doc['category'] as String).toList();
      final friendPhotoTags = snapshot.docs
          .map((doc) => Map<String, String?>.from(doc['tags'] as Map))
          .toList();
      final friendPhotoLikes =
          snapshot.docs.map((doc) => doc['isLiked'] as bool).toList();

      emit(state.copyWith(
        friendPhotoPaths: friendPhotoPaths,
        friendPhotoCategories: friendPhotoCategories,
        friendPhotoTags: friendPhotoTags,
        friendPhotoLikes: friendPhotoLikes,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print("Error loading friend's closet: $e");
    }
  }
}
