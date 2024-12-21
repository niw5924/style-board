import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showCategoryTagPopup(BuildContext context) {
  String? selectedCategory;
  String? selectedSeason;
  String? selectedColor;
  String? selectedStyle;
  String? selectedPurpose;

  final categories = ['상의', '하의', '아우터', '기타'];
  final seasons = ['봄', '여름', '가을', '겨울'];
  final colors = ['빨강', '파랑', '초록', '노랑'];
  final styles = ['캐주얼', '포멀', '스포티', '트렌디'];
  final purposes = ['일상', '운동', '여행', '파티'];

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('카테고리 및 태그 설정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '카테고리 선택'),
              items: categories
                  .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedCategory = value;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: '계절 선택'),
                    items: seasons
                        .map((season) => DropdownMenuItem<String>(
                              value: season,
                              child: Text(season),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedSeason = value;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: '색상 선택'),
                    items: colors
                        .map((color) => DropdownMenuItem<String>(
                              value: color,
                              child: Text(color),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedColor = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: '스타일 선택'),
                    items: styles
                        .map((style) => DropdownMenuItem<String>(
                              value: style,
                              child: Text(style),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedStyle = value;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: '용도 선택'),
                    items: purposes
                        .map((purpose) => DropdownMenuItem<String>(
                              value: purpose,
                              child: Text(purpose),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedPurpose = value;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedCategory != null &&
                  selectedSeason != null &&
                  selectedColor != null &&
                  selectedStyle != null &&
                  selectedPurpose != null) {
                Navigator.pop(context, {
                  'category': selectedCategory,
                  'tags': {
                    'season': selectedSeason,
                    'color': selectedColor,
                    'style': selectedStyle,
                    'purpose': selectedPurpose,
                  },
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('모든 태그를 설정해주세요.')),
                );
              }
            },
            child: const Text('완료'),
          ),
        ],
      );
    },
  );
}
