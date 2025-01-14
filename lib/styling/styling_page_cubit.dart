import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'styling_page_state.dart';
import 'package:style_board/auth/auth_provider.dart';

class StylingPageCubit extends Cubit<StylingPageState> {
  final AuthProvider authProvider;

  StylingPageCubit(this.authProvider) : super(const StylingPageState());

  String get _userId => authProvider.user!.uid;

  Future<void> loadPhotosByCategory(String category) async {
    emit(state.copyWith(isLoading: true, selectedCategory: category));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('photos')
          .where('category', isEqualTo: category)
          .get();

      final photos = snapshot.docs.map((doc) => doc['path'] as String).toList();

      emit(state.copyWith(isLoading: false, categoryPhotos: photos));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectPhoto(String category, String photo) {
    final updatedPhotos = Map<String, String>.from(state.selectedPhotos)
      ..[category] = photo;

    emit(state.copyWith(selectedPhotos: updatedPhotos));
  }

  void resetAllPhotos() {
    emit(state.copyWith(selectedPhotos: {}));
  }
}
