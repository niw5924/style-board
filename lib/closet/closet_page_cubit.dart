import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'closet_item.dart';
import 'closet_page_state.dart';

class ClosetPageCubit extends Cubit<ClosetPageState> {
  final AuthProvider authProvider;
  final ImagePicker _imagePicker = ImagePicker();

  ClosetPageCubit(this.authProvider) : super(const ClosetPageState());

  String get _userId => authProvider.user!.uid;

  Future<void> loadUserPhotos() async {
    emit(state.copyWith(
      filterCategory: null,
      filterSeason: null,
      filterColor: null,
      filterStyle: null,
      filterPurpose: null,
      isLoading: true,
    ));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
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

      emit(state.copyWith(closetItems: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<XFile?> takePhoto() async {
    try {
      return await _imagePicker.pickImage(source: ImageSource.camera);
    } catch (e) {
      return null;
    }
  }

  Future<XFile?> pickPhotoFromGallery() async {
    try {
      return await _imagePicker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      return null;
    }
  }

  Future<void> savePhotoWithDetails({
    required XFile pickedXFile,
    required String category,
    required Map<String, String> tags,
    required bool isLiked,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      final originalName = pickedXFile.name;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${originalName}_$timestamp';

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_photos')
          .child(_userId)
          .child(fileName);

      final imageFile = File(pickedXFile.path);
      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('photos')
          .add({
        'path': downloadUrl,
        'category': category,
        'tags': tags,
        'isLiked': isLiked,
        'timestamp': FieldValue.serverTimestamp(),
      });

      final newItem = ClosetItem(
        path: downloadUrl,
        category: category,
        tags: tags,
        isLiked: isLiked,
      );

      emit(state.copyWith(
        closetItems: [...state.closetItems, newItem],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void togglePhotoLike(int index) async {
    final updatedItems = List<ClosetItem>.from(state.closetItems);
    final currentItem = updatedItems[index];
    final updatedItem = ClosetItem(
      path: currentItem.path,
      category: currentItem.category,
      tags: currentItem.tags,
      isLiked: !currentItem.isLiked,
    );
    updatedItems[index] = updatedItem;

    emit(state.copyWith(closetItems: updatedItems));

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('photos')
          .where('path', isEqualTo: currentItem.path)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          snapshot.docs.first.reference
              .update({'isLiked': updatedItem.isLiked});
        }
      });
    } catch (e) {
      print('좋아요 업데이트 중 오류 발생: $e');
    }
  }

  List<ClosetItem> getFilteredClosetItems() {
    return state.closetItems.where((item) {
      final matchCategory =
          state.filterCategory == null || item.category == state.filterCategory;
      final matchSeason = state.filterSeason == null ||
          item.tags['season'] == state.filterSeason;
      final matchColor =
          state.filterColor == null || item.tags['color'] == state.filterColor;
      final matchStyle =
          state.filterStyle == null || item.tags['style'] == state.filterStyle;
      final matchPurpose = state.filterPurpose == null ||
          item.tags['purpose'] == state.filterPurpose;

      return matchCategory &&
          matchSeason &&
          matchColor &&
          matchStyle &&
          matchPurpose;
    }).toList();
  }

  void updateCategory(String? category) {
    emit(state.copyWith(filterCategory: category));
  }

  void updateSeason(String? season) {
    emit(state.copyWith(filterSeason: season));
  }

  void updateColor(String? color) {
    emit(state.copyWith(filterColor: color));
  }

  void updateStyle(String? style) {
    emit(state.copyWith(filterStyle: style));
  }

  void updatePurpose(String? purpose) {
    emit(state.copyWith(filterPurpose: purpose));
  }
}
