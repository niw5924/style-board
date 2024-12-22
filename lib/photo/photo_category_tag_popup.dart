import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showCategoryTagPopup(BuildContext context) {
  String? selectedCategory;
  String? selectedSeason;
  String? selectedColor;
  String? selectedStyle;
  String? selectedPurpose;

  final categories = ['상의', '하의', '아우터', '기타'];
  final seasons = ['봄', '여름', '가을', '겨울'];
  final colors = ['빨강', '파랑', '초록', '노랑', '검정', '흰색', '회색', '보라', '분홍'];
  final styles = ['캐주얼', '포멀', '스포티', '트렌디'];
  final purposes = ['일상', '운동', '여행', '파티'];

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '카테고리 및 태그 설정',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: '카테고리 선택',
                  items: categories,
                  onChanged: (value) {
                    selectedCategory = value;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: '계절 선택',
                        items: seasons,
                        onChanged: (value) {
                          selectedSeason = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDropdown(
                        label: '색상 선택',
                        items: colors,
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
                      child: _buildDropdown(
                        label: '스타일 선택',
                        items: styles,
                        onChanged: (value) {
                          selectedStyle = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDropdown(
                        label: '용도 선택',
                        items: purposes,
                        onChanged: (value) {
                          selectedPurpose = value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    const SizedBox(width: 8),
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
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDropdown({
  required String label,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade200,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0077CC), width: 2),
      ),
    ),
    items: items
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ))
        .toList(),
    onChanged: onChanged,
  );
}
