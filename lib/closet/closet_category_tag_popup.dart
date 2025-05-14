import 'dart:io';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> closetCategoryTagPopup(
  BuildContext context,
  File? photoFile,
) {
  String? selectedCategory;
  String? selectedSeason;
  String? selectedColor;
  String? selectedStyle;
  String? selectedPurpose;
  bool isLiked = false;

  final categories = ['상의', '하의', '아우터', '신발'];
  final seasons = ['봄', '여름', '가을', '겨울'];
  final colors = ['빨강', '파랑', '초록', '노랑', '검정', '흰색', '회색', '보라', '베이지', '갈색'];
  final styles = ['캐주얼', '포멀', '스포티', '트렌디', '빈티지', '모던'];
  final purposes = ['일상', '운동', '여행', '파티', '출근', '데이트'];

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      bool showError = false;
      String errorMessage = '';

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            insetPadding: const EdgeInsets.all(16),
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (photoFile != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            photoFile,
                            width: double.infinity,
                            height: 260,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  if (photoFile != null) const SizedBox(height: 16),
                  const Text(
                    '카테고리 및 태그 설정',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: '카테고리 선택',
                    items: categories,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
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
                            setState(() {
                              selectedSeason = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDropdown(
                          label: '색상 선택',
                          items: colors,
                          onChanged: (value) {
                            setState(() {
                              selectedColor = value;
                            });
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
                            setState(() {
                              selectedStyle = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDropdown(
                          label: '용도 선택',
                          items: purposes,
                          onChanged: (value) {
                            setState(() {
                              selectedPurpose = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AnimatedOpacity(
                    opacity: showError ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('취소'),
                      ),
                      const SizedBox(width: 12),
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
                              'isLiked': isLiked,
                            });
                          } else {
                            setState(() {
                              showError = true;
                              errorMessage = '모든 태그를 설정해주세요.';
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                showError = false;
                                errorMessage = '';
                              });
                            });
                          }
                        },
                        child: const Text('완료'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
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
