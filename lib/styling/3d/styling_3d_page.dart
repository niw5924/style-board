import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:style_board/styling/category_tile.dart';
import 'package:style_board/styling/styling_page_cubit.dart';

class Styling3DPage extends StatefulWidget {
  const Styling3DPage({super.key});

  @override
  _Styling3DPageState createState() => _Styling3DPageState();
}

class _Styling3DPageState extends State<Styling3DPage> {
  final Map<String, String?> _glbUrls = {
    '상의': null,
    '하의': null,
    '아우터': null,
    '신발': null,
  };
  final Map<String, bool> _isLoading = {
    '상의': false,
    '하의': false,
    '아우터': false,
    '신발': false,
  };

  @override
  void initState() {
    super.initState();
  }

  /// 로컬 이미지 파일을 Base64로 변환
  Future<String> convertImageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64String = base64Encode(imageBytes);

    return "data:image/png;base64,$base64String";
  }

  /// 한글 카테고리를 영문 파일명으로 변환
  String getSafeFilename(String category) {
    final Map<String, String> categoryToEnglish = {
      '상의': 'top',
      '하의': 'bottom',
      '아우터': 'outer',
      '신발': 'shoes',
    };

    return categoryToEnglish[category]!;
  }

  /// GLB 파일을 각 카테고리별로 저장
  Future<String?> downloadGLBFile(String url, String category) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final safeCategory = getSafeFilename(category);
        final filePath = "${directory.path}/${safeCategory}_$timestamp.glb";
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print('GLB 파일 다운로드 완료: $filePath');
        return filePath;
      } else {
        print('GLB 파일 다운로드 실패: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('GLB 다운로드 중 오류 발생: $e');
      return null;
    }
  }

  /// GLB 파일을 다운로드할 때 해당 카테고리만 로딩 표시
  Future<void> checkJobStatus(
    String taskId,
    int index,
    List<String> imagePaths,
    List<String> categories,
  ) async {
    final category = categories[index];
    setState(() {
      _isLoading[category] = true;
    });

    final apiKey = dotenv.env['MESHY_API_KEY'];
    final url =
        Uri.parse('https://api.meshy.ai/openapi/v1/image-to-3d/$taskId');

    while (true) {
      try {
        final response = await http.get(
          url,
          headers: {'Authorization': 'Bearer $apiKey'},
        );

        final data = jsonDecode(response.body);
        print(data);

        if (data.containsKey('status')) {
          if (data['status'] == 'SUCCEEDED' &&
              data['model_urls'].containsKey('glb')) {
            final localPath =
                await downloadGLBFile(data['model_urls']['glb'], category);
            if (localPath != null) {
              setState(() {
                _glbUrls[category] = localPath;
                _isLoading[category] = false;
              });
            }
            // 다음 이미지 변환 시작
            await _convertImagesTo3DModels(imagePaths, index + 1, categories);
            return;
          } else if (data['status'] == 'FAILED') {
            print('변환 실패: $data');
            setState(() {
              _isLoading[category] = false;
            });
            return;
          }
        }
      } catch (e) {
        print('변환 상태 확인 중 오류 발생: $e');
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  /// 선택한 모든 옷을 차례대로 3D 변환 (카테고리 추가)
  Future<void> _convertImagesTo3DModels(
    List<String> imagePaths,
    int index,
    List<String> categories,
  ) async {
    if (index >= imagePaths.length) {
      return; // 모든 변환 완료
    }

    final category = categories[index]; // 현재 변환할 카테고리
    setState(() => _isLoading[category] = true); // 해당 카테고리 로딩 시작

    final apiKey = dotenv.env['MESHY_API_KEY'];
    final url = Uri.parse('https://api.meshy.ai/openapi/v1/image-to-3d');

    try {
      String base64Image = await convertImageToBase64(imagePaths[index]);

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image_url': base64Image,
          'enable_pbr': true,
          'should_remesh': true,
          'should_texture': true,
        }),
      );

      final data = jsonDecode(response.body);

      if (data.containsKey('result')) {
        String taskId = data['result'];
        print('Meshy 변환 작업 생성됨 (Job ID: $taskId)');

        // 변환 상태 확인
        await checkJobStatus(taskId, index, imagePaths, categories);
      } else {
        print('응답 데이터에 Job ID 없음.');
        setState(() => _isLoading[category] = false);
      }
    } catch (e) {
      print('Meshy API 오류: $e');
      setState(() => _isLoading[category] = false);
    }
  }

  /// 적용 버튼 클릭 시 선택한 모든 사진 변환
  void _start3DConversion() {
    final selectedPhotos =
        context.read<StylingPageCubit>().state.selectedPhotos;

    if (selectedPhotos.isNotEmpty) {
      Navigator.pop(context);

      List<String> imagePaths = selectedPhotos.values.toList();
      List<String> categories = selectedPhotos.keys.toList();

      _convertImagesTo3DModels(imagePaths, 0, categories);
    } else {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('옷을 선택해주세요!')),
      );
    }
  }

  /// 옷 선택 UI (카테고리 선택 기능)
  void _showCategorySelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                '사진을 선택하면 3D로 변환해 드릴게요!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final categories = ['상의', '하의', '아우터', '신발'];
                    final category = categories[index];

                    return CategoryTile(category: category);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  onPressed: _start3DConversion,
                  child: const Text('변환'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModelView('상의', _glbUrls['상의']),
                const SizedBox(height: 20),
                _buildModelView('하의', _glbUrls['하의']),
                const SizedBox(height: 20),
                _buildModelView('신발', _glbUrls['신발']),
              ],
            ),
            const SizedBox(width: 40),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModelView('아우터', _glbUrls['아우터']),
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: _showCategorySelectionSheet,
                  child: const Text('옷장 열기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 3D 모델 뷰어 위젯 생성
  Widget _buildModelView(String category, String? glbUrl) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _isLoading[category] == true
              ? const Center(child: CircularProgressIndicator())
              : glbUrl != null
                  ? ModelViewer(
                      src: 'file://$glbUrl',
                      alt: 'A 3D model of $category',
                      ar: false,
                      autoRotate: false,
                      disableZoom: false,
                    )
                  : Icon(
                      Icons.threed_rotation,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                    ),
        ),
      ],
    );
  }
}
