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

  // Firestore에서 사용자별 사진 로드
  Future<void> loadUserPhotos() async {
    emit(state.copyWith(isLoading: true));
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('photos')
          .orderBy('timestamp', descending: false) // 오래된 순으로 정렬
          .get();

      final photoPaths =
          snapshot.docs.map((doc) => doc['path'] as String).toList();
      emit(state.copyWith(photoPaths: photoPaths, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // 카메라로 사진 찍고 Firestore에 저장
  Future<void> takePhoto() async {
    emit(state.copyWith(isLoading: true));
    try {
      // 1. 카메라로 사진 찍기
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile == null) {
        emit(state.copyWith(isLoading: false));
        return; // 사진 찍기가 취소된 경우
      }

      final filePath = pickedFile.path; // 로컬 경로 가져오기

      // 2. Firestore에 사진 경로 저장
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('photos')
          .add({
        'path': filePath, // 로컬 경로 저장
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 3. 상태 업데이트
      final updatedPhotoPaths = List<String>.from(state.photoPaths)
        ..add(filePath);
      emit(state.copyWith(photoPaths: updatedPhotoPaths, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
