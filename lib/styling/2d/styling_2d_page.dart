import 'package:flutter/material.dart';
import 'package:style_board/styling/category_tile.dart';

class Styling2DPage extends StatelessWidget {
  const Styling2DPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CategoryTile(category: '상의'),
                SizedBox(height: 20),
                CategoryTile(category: '하의'),
                SizedBox(height: 20),
                CategoryTile(category: '신발'),
              ],
            ),
            SizedBox(width: 40),
            CategoryTile(category: '아우터'),
          ],
        ),
      ),
    );
  }
}
