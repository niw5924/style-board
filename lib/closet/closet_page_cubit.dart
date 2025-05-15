import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'package:style_board/closet/closet_page_state.dart';

class ClosetPageCubit extends Cubit<ClosetPageState> {
  final AuthProvider authProvider;
  final ImagePicker _imagePicker = ImagePicker();

  ClosetPageCubit(this.authProvider) : super(const ClosetPageState());

  String get _userId => authProvider.user!.uid;

  Future<void> loadUserPhotos() async {
    // 필터 상태 초기화
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

      final photoPaths =
          snapshot.docs.map((doc) => doc['path'] as String).toList();
      final photoCategories =
          snapshot.docs.map((doc) => doc['category'] as String).toList();
      final photoTags = snapshot.docs
          .map((doc) => Map<String, String?>.from(doc['tags'] as Map))
          .toList();
      final photoLikes =
          snapshot.docs.map((doc) => doc['isLiked'] as bool).toList();

      emit(state.copyWith(
        photoPaths: photoPaths,
        photoCategories: photoCategories,
        photoTags: photoTags,
        photoLikes: photoLikes,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<XFile?> takePhoto() async {
    try {
      final pickedXFile =
          await _imagePicker.pickImage(source: ImageSource.camera);
      return pickedXFile;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<XFile?> pickPhotoFromGallery() async {
    try {
      final pickedXFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      return pickedXFile;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> savePhotoWithDetails({
    required XFile pickedXFile,
    required String category,
    required Map<String, String?> tags,
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

      final updatedPhotoPaths = List<String>.from(state.photoPaths)
        ..add(downloadUrl);
      final updatedPhotoCategories = List<String>.from(state.photoCategories)
        ..add(category);
      final updatedPhotoTags = List<Map<String, String?>>.from(state.photoTags)
        ..add(tags);
      final updatedPhotoLikes = List<bool>.from(state.photoLikes)..add(isLiked);

      emit(state.copyWith(
        photoPaths: updatedPhotoPaths,
        photoCategories: updatedPhotoCategories,
        photoTags: updatedPhotoTags,
        photoLikes: updatedPhotoLikes,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void togglePhotoLike(int index) async {
    final updatedLikes = List<bool>.from(state.photoLikes);
    updatedLikes[index] = !updatedLikes[index];

    emit(state.copyWith(photoLikes: updatedLikes));

    try {
      final photoPath = state.photoPaths[index];
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('photos')
          .where('path', isEqualTo: photoPath)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          snapshot.docs.first.reference.update({
            'isLiked': updatedLikes[index],
          });
        }
      });
    } catch (e) {
      print("Error updating like status: $e");
    }
  }

  // 필터 조건에 맞는 사진 인덱스를 반환하는 메서드 추가
  List<int> getFilteredPhotoIndices() {
    final indices = <int>[];

    for (int i = 0; i < state.photoPaths.length; i++) {
      final matchesCategory = state.filterCategory == null ||
          state.photoCategories[i] == state.filterCategory;

      final matchesSeason = state.filterSeason == null ||
          state.photoTags[i]['season'] == state.filterSeason;

      final matchesColor = state.filterColor == null ||
          state.photoTags[i]['color'] == state.filterColor;

      final matchesStyle = state.filterStyle == null ||
          state.photoTags[i]['style'] == state.filterStyle;

      final matchesPurpose = state.filterPurpose == null ||
          state.photoTags[i]['purpose'] == state.filterPurpose;

      if (matchesCategory &&
          matchesSeason &&
          matchesColor &&
          matchesStyle &&
          matchesPurpose) {
        indices.add(i);
      }
    }

    return indices;
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
