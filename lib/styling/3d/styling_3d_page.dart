import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:style_board/styling/3d/styling_3d_page_cubit.dart';
import 'package:style_board/styling/3d/styling_3d_page_state.dart';
import 'package:style_board/widgets/category_tile.dart';
import 'package:style_board/styling/styling_page_cubit.dart';

class Styling3DPage extends StatelessWidget {
  const Styling3DPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModelView(context, '상의'),
              const SizedBox(height: 20),
              _buildModelView(context, '하의'),
              const SizedBox(height: 20),
              _buildModelView(context, '신발'),
            ],
          ),
          const SizedBox(width: 40),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModelView(context, '아우터'),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () => _showCategorySelectionSheet(context),
                child: const Text('옷장 열기'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 3D 모델 뷰어 위젯
  Widget _buildModelView(BuildContext context, String category) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          category,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<Styling3DPageCubit, Styling3DPageState>(
          builder: (context, state) {
            final glbUrl = state.glbUrls[category];
            final isLoading = state.isLoading[category] == true;
            final progress = state.progress[category];

            return Stack(
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: (isLoading && progress != null)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              '$progress%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
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
                if (glbUrl != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<Styling3DPageCubit>()
                            .remove3DModel(category);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.surface,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// 카테고리 선택 UI
  void _showCategorySelectionSheet(BuildContext scaffoldContext) {
    showModalBottomSheet(
      context: scaffoldContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
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
                '3D 변환',
                textAlign: TextAlign.center,
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
                    return CategoryTile(category: categories[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: () => _start3DConversion(scaffoldContext),
                  child: const Text('변환하기'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 3D 변환
  void _start3DConversion(BuildContext scaffoldContext) async {
    final selectedPhotos =
        scaffoldContext.read<StylingPageCubit>().state.selectedPhotos;

    if (selectedPhotos.isNotEmpty) {
      Navigator.pop(scaffoldContext);

      final imagePaths = selectedPhotos.values.toList();
      final categories = selectedPhotos.keys.toList();

      try {
        await scaffoldContext
            .read<Styling3DPageCubit>()
            .convertImagesTo3DModels(imagePaths, categories, 0);
      } catch (e) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } else {
      Navigator.pop(scaffoldContext);

      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(content: Text('옷을 선택해주세요!')),
      );
    }
  }
}
