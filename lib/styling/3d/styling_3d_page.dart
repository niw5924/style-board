import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/constants/closet_data.dart';
import 'package:style_board/main.dart';
import 'package:style_board/styling/3d/styling_3d_page_cubit.dart';
import 'package:style_board/styling/styling_page_cubit.dart';
import 'package:style_board/widgets/category_tile_2d.dart';
import 'package:style_board/widgets/category_tile_3d.dart';

class Styling3DPage extends StatelessWidget {
  const Styling3DPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CategoryTile3D(category: '상의'),
            SizedBox(height: 20),
            CategoryTile3D(category: '하의'),
            SizedBox(height: 20),
            CategoryTile3D(category: '신발'),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            const CategoryTile3D(category: '아우터'),
            SizedBox(height: MediaQuery.of(context).size.width * 0.2),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
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
                              color: Colors.grey.shade300,
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
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                return CategoryTile2D(
                                    category: categories[index]);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);

                                final selectedPhotos = context
                                    .read<StylingPageCubit>()
                                    .state
                                    .selectedPhotos;

                                if (selectedPhotos.isNotEmpty) {
                                  final imagePaths =
                                      selectedPhotos.values.toList();
                                  final selectedCategories =
                                      selectedPhotos.keys.toList();

                                  try {
                                    await context
                                        .read<Styling3DPageCubit>()
                                        .convertImagesTo3DModels(
                                            imagePaths, selectedCategories, 0);
                                  } catch (e) {
                                    scaffoldMessengerKey.currentState
                                        ?.showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                } else {
                                  scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                                    const SnackBar(content: Text('옷을 선택해주세요!')),
                                  );
                                }
                              },
                              child: const Text('변환하기'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Text('옷장 열기'),
            ),
          ],
        ),
      ],
    );
  }
}
