import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_board/widgets/common_popup_layout.dart';

class ClosetCategoryTagPopup extends StatefulWidget {
  final XFile pickedXFile;

  const ClosetCategoryTagPopup({super.key, required this.pickedXFile});

  @override
  State<ClosetCategoryTagPopup> createState() => _ClosetCategoryTagPopupState();
}

class _ClosetCategoryTagPopupState extends State<ClosetCategoryTagPopup> {
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

  @override
  Widget build(BuildContext context) {
    final imageFile = File(widget.pickedXFile.path);

    return CommonPopupLayout(
      icon: Icons.category,
      title: '카테고리 및 태그 설정',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  imageFile,
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
          const SizedBox(height: 16),
          _buildDropdown(
            label: '카테고리 선택',
            items: categories,
            onChanged: (value) => setState(() => selectedCategory = value),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: '계절 선택',
                  items: seasons,
                  onChanged: (value) => setState(() => selectedSeason = value),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  label: '색상 선택',
                  items: colors,
                  onChanged: (value) => setState(() => selectedColor = value),
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
                  onChanged: (value) => setState(() => selectedStyle = value),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown(
                  label: '용도 선택',
                  items: purposes,
                  onChanged: (value) => setState(() => selectedPurpose = value),
                ),
              ),
            ],
          ),
        ],
      ),
      cancelText: '취소',
      confirmText: '완료',
      onCancel: () => Navigator.pop(context),
      onConfirm: () async {
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
          return null;
        } else {
          return '모든 태그를 설정해주세요.';
        }
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
}
