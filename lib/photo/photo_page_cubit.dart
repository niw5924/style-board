import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_board/auth/auth_provider.dart';
import 'photo_page_state.dart';

class PhotoPageCubit extends Cubit<PhotoPageState> {
  final AuthProvider authProvider;
  final ImagePicker _imagePicker = ImagePicker();

  PhotoPageCubit(this.authProvider) : super(const PhotoPageState());

  String get _userId => authProvider.user!.uid;

  Future<void> loadUserPhotos() async {
    emit(state.copyWith(isLoading: true));
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

      emit(state.copyWith(
        photoPaths: photoPaths,
        photoCategories: photoCategories,
        photoTags: photoTags,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<XFile?> takePhoto() async {
    emit(state.copyWith(isLoading: true));
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );

      emit(state.copyWith(isLoading: false));
      return pickedFile;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return null;
    }
  }

  Future<void> savePhotoWithDetails({
    required String filePath,
    required String category,
    required Map<String, String?> tags,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('photos')
          .add({
        'path': filePath,
        'category': category,
        'tags': tags,
        'timestamp': FieldValue.serverTimestamp(),
      });

      final updatedPhotoPaths = List<String>.from(state.photoPaths)
        ..add(filePath);
      final updatedPhotoCategories = List<String>.from(state.photoCategories)
        ..add(category);
      final updatedPhotoTags = List<Map<String, String?>>.from(state.photoTags)
        ..add(tags);

      emit(state.copyWith(
        photoPaths: updatedPhotoPaths,
        photoCategories: updatedPhotoCategories,
        photoTags: updatedPhotoTags,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}