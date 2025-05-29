import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'styling_page_state.dart';

class StylingPageCubit extends Cubit<StylingPageState> {
  final String userId;

  StylingPageCubit(this.userId) : super(const StylingPageState());

  void updateSelectedTab(int tabIndex) {
    emit(state.copyWith(selectedTab: tabIndex));
  }

  Future<void> loadPhotosByCategory(String category) async {
    emit(state.copyWith(isLoading: true, selectedCategory: category));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
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

  void removePhoto(String category) {
    final updatedPhotos = Map<String, String>.from(state.selectedPhotos)
      ..remove(category);

    emit(state.copyWith(selectedPhotos: updatedPhotos));
  }

  void resetAllPhotos() {
    emit(state.copyWith(selectedPhotos: {}));
  }

  bool areAllCategoriesSelected() {
    const requiredCategories = ['상의', '하의', '아우터', '신발'];
    return requiredCategories
        .every((category) => state.selectedPhotos.containsKey(category));
  }

  Future<void> addToMyPickWithName(String pickName) async {
    final selectedPhotos = state.selectedPhotos;

    final myPicksRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myPicks');

    await myPicksRef.add({
      'name': pickName,
      ...selectedPhotos,
      'createdAt': DateTime.now(),
    });
  }
}
