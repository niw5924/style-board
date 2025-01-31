// import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:path_provider/path_provider.dart';
import 'styling_page_state.dart';
import 'package:style_board/auth/auth_provider.dart';
// import 'package:http/http.dart' as http;

class StylingPageCubit extends Cubit<StylingPageState> {
  final AuthProvider authProvider;

  StylingPageCubit(this.authProvider) : super(const StylingPageState());

  String get _userId => authProvider.user!.uid;

  void updateSelectedTab(int tabIndex) {
    emit(state.copyWith(selectedTab: tabIndex));
  }

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

  bool areAllCategoriesSelected() {
    const requiredCategories = ['상의', '하의', '아우터', '신발'];
    return requiredCategories
        .every((category) => state.selectedPhotos.containsKey(category));
  }

  Future<void> addToMyPickWithName(String pickName) async {
    final selectedPhotos = state.selectedPhotos;

    final myPicksRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('myPicks');

    try {
      await myPicksRef.add({
        'name': pickName,
        ...selectedPhotos,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('나의 Pick 저장 중 오류가 발생했습니다: $e');
    }
  }

  // Payment Required
  // Future<void> applyBackgroundRemoval() async {
  //   final selectedPhotos = state.selectedPhotos;
  //
  //   for (var category in selectedPhotos.keys) {
  //     String imagePath = selectedPhotos[category]!;
  //
  //     try {
  //       // 배경 제거 실행
  //       var request = http.MultipartRequest(
  //         'POST',
  //         Uri.parse('https://api.remove.bg/v1.0/removebg'),
  //       );
  //
  //       request.headers.addAll({
  //         'X-Api-Key': dotenv.env['REMOVE_BG_API_KEY']!,
  //       });
  //
  //       request.files
  //           .add(await http.MultipartFile.fromPath('image_file', imagePath));
  //
  //       var response = await request.send();
  //
  //       if (response.statusCode == 200) {
  //         var bytes = await response.stream.toBytes();
  //         final dir = await getApplicationDocumentsDirectory();
  //         final newPath = '${dir.path}/${imagePath.split('/').last}_no_bg.png';
  //         final file = File(newPath);
  //         await file.writeAsBytes(bytes);
  //
  //         print('배경 제거된 이미지 [$category]: $newPath');
  //       } else {
  //         print('Error: ${response.reasonPhrase}');
  //       }
  //     } catch (e) {
  //       print('Background removal error: $e');
  //     }
  //   }
  // }
}
