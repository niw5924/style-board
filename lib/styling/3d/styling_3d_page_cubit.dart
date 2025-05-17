import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'styling_3d_page_state.dart';

class Styling3DPageCubit extends Cubit<Styling3DPageState> {
  Styling3DPageCubit() : super(const Styling3DPageState());

  /// 한글 카테고리를 영문 파일명으로 변환
  String _getSafeFilename(String category) {
    final Map<String, String> categoryToEnglish = {
      '상의': 'top',
      '하의': 'bottom',
      '아우터': 'outer',
      '신발': 'shoes',
    };

    return categoryToEnglish[category]!;
  }

  /// Firebase Storage 이미지 URL을 Base64 문자열로 변환
  Future<String> _convertImageToBase64(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('이미지 다운로드 실패: ${response.statusCode}');
    }
    return "data:image/png;base64,${base64Encode(response.bodyBytes)}";
  }

  /// GLB 파일 다운로드 및 로컬 저장
  Future<String?> _downloadGLBFile(String url, String category) async {
    print('[$category] GLB 다운로드 시작...');

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final safeCategory = _getSafeFilename(category);
        final filePath = "${directory.path}/$safeCategory.glb";
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print('[$category] GLB 다운로드 완료: $filePath');
        return filePath;
      } else {
        print('[$category] GLB 다운로드 실패 (응답 코드: ${response.statusCode})');
      }
    } catch (e) {
      print('[$category] GLB 다운로드 중 오류 발생: $e');
    }
    return null;
  }

  /// 변환 상태 확인 (GLB 모델 다운로드까지 처리)
  Future<void> _checkJobStatus(
    String taskId,
    String category,
    List<String> imagePaths,
    List<String> categories,
    int index,
  ) async {
    print('[$category] 변환 상태 확인 중...');
    emit(state.copyWith(isLoading: {...state.isLoading, category: true}));

    final apiKey = dotenv.env['MESHY_API_KEY'];
    final url =
        Uri.parse('https://api.meshy.ai/openapi/v1/image-to-3d/$taskId');

    while (true) {
      try {
        final response =
            await http.get(url, headers: {'Authorization': 'Bearer $apiKey'});
        final data = jsonDecode(response.body);
        print(data);

        if (data.containsKey('progress')) {
          final int progress = data['progress'];
          emit(state.copyWith(
            progress: {...state.progress, category: progress},
          ));
        }

        if (data['status'] == 'SUCCEEDED' &&
            data['model_urls'].containsKey('glb')) {
          print('[$category] 변환 완료! GLB 다운로드 시작...');

          final localPath =
              await _downloadGLBFile(data['model_urls']['glb'], category);
          if (localPath != null) {
            emit(state.copyWith(
              glbUrls: {...state.glbUrls, category: localPath},
              // GLB 모델 저장
              isLoading: {...state.isLoading, category: false},
              // 변환 완료 후 false 설정
              progress: {
                ...state.progress,
                category: null
              }, // 변환 완료 후 progress 제거
            ));
            print('[$category] GLB 다운로드 및 저장 완료.');
          }

          await convertImagesTo3DModels(imagePaths, categories, index + 1);
          return;
        } else if (data['status'] == 'FAILED') {
          print('[$category] 변환 실패!');
          emit(
              state.copyWith(isLoading: {...state.isLoading, category: false}));
          return;
        } else {
          print('[$category] 변환 진행 중... ${data['progress']}% 완료');
        }
      } catch (e) {
        print('[$category] 변환 상태 확인 중 오류 발생: $e');
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  /// 3D 변환 요청 (한 번에 하나씩 변환)
  Future<void> convertImagesTo3DModels(
    List<String> imagePaths,
    List<String> categories,
    int index,
  ) async {
    if (index >= imagePaths.length) {
      print('모든 이미지 변환 완료.');
      return;
    }

    final category = categories[index];
    print('[$category] 변환 시작...');

    emit(state.copyWith(isLoading: {...state.isLoading, category: true}));

    final apiKey = dotenv.env['MESHY_API_KEY'];
    final url = Uri.parse('https://api.meshy.ai/openapi/v1/image-to-3d');

    try {
      String base64Image = await _convertImageToBase64(imagePaths[index]);

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'image_url': base64Image}),
      );

      final data = jsonDecode(response.body);
      if (data.containsKey('result')) {
        String taskId = data['result'];
        print('[$category] 변환 요청 성공 (Task ID: $taskId)');

        await _checkJobStatus(taskId, category, imagePaths, categories, index);
      } else {
        print('[$category] 변환 요청 실패 (응답 데이터 없음)');
        throw '[$category] 변환 요청 실패: 서버에서 Task ID를 받지 못했습니다.';
      }
    } catch (e) {
      print('[$category] 변환 중 오류 발생: $e');
      emit(state.copyWith(isLoading: {...state.isLoading, category: false}));
      throw '[$category] 변환 중 오류 발생';
    }
  }

  /// 특정 카테고리의 3D 모델 삭제
  void remove3DModel(String category) {
    final updatedGlbUrls = Map<String, String?>.from(state.glbUrls)
      ..remove(category);

    emit(state.copyWith(glbUrls: updatedGlbUrls));
  }
}
