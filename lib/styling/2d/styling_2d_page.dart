import 'package:flutter/material.dart';
import 'package:style_board/widgets/category_tile_2d.dart';

class Styling2DPage extends StatelessWidget {
  const Styling2DPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CategoryTile2D(category: '상의'),
            SizedBox(height: 20),
            CategoryTile2D(category: '하의'),
            SizedBox(height: 20),
            CategoryTile2D(category: '신발'),
          ],
        ),
        SizedBox(width: 20),
        CategoryTile2D(category: '아우터'),
      ],
    );
  }
}
