import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showFilterBottomSheet(
    BuildContext context) async {
  final categories = ['상의', '하의', '아우터', '신발'];
  final seasons = ['봄', '여름', '가을', '겨울'];
  final colors = ['빨강', '파랑', '초록', '노랑', '검정', '흰색', '회색', '보라', '베이지', '갈색'];
  final styles = ['캐주얼', '포멀', '스포티', '트렌디', '빈티지', '모던'];
  final purposes = ['일상', '운동', '여행', '파티', '출근', '데이트'];

  final sections = ['카테고리', '계절', '색상', '스타일', '용도'];
  final sectionData = {
    '카테고리': categories,
    '계절': seasons,
    '색상': colors,
    '스타일': styles,
    '용도': purposes,
  };

  String selectedSection = '카테고리';
  String? selectedCategory;
  final selectedTags = <String, String?>{
    '계절': null,
    '색상': null,
    '스타일': null,
    '용도': null,
  };

  return await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final currentOptions = sectionData[selectedSection]!;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "필터",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedCategory = null;
                          selectedTags.updateAll((key, value) => null);
                        });
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text("전체 초기화"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: sections.length,
                        itemBuilder: (context, index) {
                          final section = sections[index];
                          final isSelected = section == selectedSection;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSection = section;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              child: Text(
                                section,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: currentOptions.length > 4
                          ? GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 3,
                              ),
                              itemCount: currentOptions.length,
                              itemBuilder: (context, index) {
                                final option = currentOptions[index];
                                final isSelected = selectedSection == '카테고리'
                                    ? selectedCategory == option
                                    : selectedTags[selectedSection] == option;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedSection == '카테고리') {
                                        selectedCategory =
                                            isSelected ? null : option;
                                      } else {
                                        selectedTags[selectedSection] =
                                            isSelected ? null : option;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: currentOptions.map((option) {
                                final isSelected = selectedSection == '카테고리'
                                    ? selectedCategory == option
                                    : selectedTags[selectedSection] == option;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedSection == '카테고리') {
                                        selectedCategory =
                                            isSelected ? null : option;
                                      } else {
                                        selectedTags[selectedSection] =
                                            isSelected ? null : option;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      '카테고리': selectedCategory,
                      '태그': Map<String, String?>.from(selectedTags),
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text("필터 적용"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
