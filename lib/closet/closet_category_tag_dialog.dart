import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_board/widgets/validated_action_dialog.dart';
import 'package:style_board/constants/closet_data.dart';

class ClosetCategoryTagDialog extends StatefulWidget {
  final XFile pickedXFile;

  const ClosetCategoryTagDialog({super.key, required this.pickedXFile});

  @override
  State<ClosetCategoryTagDialog> createState() =>
      _ClosetCategoryTagDialogState();
}

class _ClosetCategoryTagDialogState extends State<ClosetCategoryTagDialog> {
  String? selectedCategory;
  String? selectedSeason;
  String? selectedColor;
  String? selectedStyle;
  String? selectedPurpose;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return ValidatedActionDialog(
      icon: Icons.category,
      title: '카테고리 및 태그 설정',
      confirmText: '완료',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(widget.pickedXFile.path),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
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
      submitIfValid: () async {
        if (selectedCategory == null) {
          return '카테고리를 선택해주세요.';
        }
        if ([selectedSeason, selectedColor, selectedStyle, selectedPurpose]
            .contains(null)) {
          return '모든 태그를 설정해주세요.';
        }
        return null;
      },
      onSuccessResult: () {
        return {
          'category': selectedCategory,
          'tags': {
            'season': selectedSeason,
            'color': selectedColor,
            'style': selectedStyle,
            'purpose': selectedPurpose,
          },
          'isLiked': isLiked,
        };
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
