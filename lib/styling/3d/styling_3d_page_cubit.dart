import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../constants/closet_data.dart';
import 'styling_3d_page_state.dart';

class Styling3DPageCubit extends Cubit<Styling3DPageState> {
  Styling3DPageCubit() : super(const Styling3DPageState());

  /// Firebase Storage 이미지 URL을 Base64 문자열로 변환
  Future<String> _convertImageToBase64(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('이미지 다운로드 실패 (${response.statusCode})');
    }
    return "data:image/png;base64,${base64Encode(response.bodyBytes)}";
  }

  /// 변환 상태를 확인해 진행률을 전달하고 GLB URL을 반환
  Future<String> _checkJobStatus({
    required String category,
    required String taskId,
    required void Function(int progress) onProgress,
  }) async {
    debugPrint('[$category] 변환 상태 확인 중...');

    final url =
        Uri.parse('https://api.meshy.ai/openapi/v1/image-to-3d/$taskId');
    final apiKey = dotenv.env['MESHY_API_KEY'];

    while (true) {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $apiKey'});
      if (response.statusCode != 200) {
        throw Exception('상태 확인 실패 (${response.statusCode})');
      }

      final data = jsonDecode(response.body);

      if (data['status'] == 'FAILED') {
        throw Exception('변환 실패');
      }

      if (data.containsKey('progress')) {
        final int progress = data['progress'];
        debugPrint('[$category] 변환 진행 중... $progress% 완료');
        onProgress(progress);
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }

      if (data['status'] == 'SUCCEEDED' &&
          data['model_urls'].containsKey('glb')) {
        return data['model_urls']['glb'];
      }
    }
  }

  /// GLB 파일 다운로드 및 로컬 저장
  Future<String> _downloadGLBFile({
    required String category,
    required String url,
  }) async {
    debugPrint('[$category] GLB 다운로드 시작...');

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('GLB 파일 다운로드 실패 (${response.statusCode})');
    }

    final directory = await getApplicationDocumentsDirectory();
    final englishCategory = categoryToEnglish[category]!;
    final filePath = "${directory.path}/$englishCategory.glb";
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    debugPrint('[$category] GLB 다운로드 완료: $filePath');
    return filePath;
  }

  /// 3D 변환 요청 (단일 카테고리 처리)
  Future<void> convertImageTo3DModel({
    required String category,
    required String imagePath,
  }) async {
    emit(state.copyWith(
      isLoading: {...state.isLoading, category: true},
      progress: {...state.progress, category: 0},
    ));
    debugPrint('[$category] 변환 시작...');

    try {
      final url = Uri.parse('https://api.meshy.ai/openapi/v1/image-to-3d');
      final apiKey = dotenv.env['MESHY_API_KEY'];
      final base64Image = await _convertImageToBase64(imagePath);

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'image_url': base64Image}),
      );

      if (response.statusCode != 200) {
        throw Exception('변환 요청 실패 (${response.statusCode})');
      }

      final data = jsonDecode(response.body);
      if (!data.containsKey('result')) {
        throw Exception('서버에서 Task ID를 받지 못했습니다.');
      }

      final taskId = data['result'];
      debugPrint('[$category] 변환 요청 성공 (Task ID: $taskId)');

      final glbUrl = await _checkJobStatus(
        category: category,
        taskId: taskId,
        onProgress: (progress) {
          emit(state
              .copyWith(progress: {...state.progress, category: progress}));
        },
      );

      final localPath = await _downloadGLBFile(
        category: category,
        url: glbUrl,
      );

      emit(state.copyWith(
        isLoading: {...state.isLoading, category: false},
        progress: {...state.progress, category: null},
        glbUrls: {...state.glbUrls, category: localPath},
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: {...state.isLoading, category: false},
        progress: {...state.progress, category: null},
      ));
      debugPrint('[$category] 변환 중 오류 발생 - $e');
      rethrow;
    }
  }

  /// 특정 카테고리의 3D 모델 삭제
  void remove3DModel(String category) {
    final updatedGlbUrls = Map<String, String?>.from(state.glbUrls)
      ..remove(category);
    emit(state.copyWith(glbUrls: updatedGlbUrls));
  }
}
