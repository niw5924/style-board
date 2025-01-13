import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> closetFilterBottomSheet(
    BuildContext context) async {
  final categories = ['상의', '하의', '아우터', '신발'];
  final seasons = ['봄', '여름', '가을', '겨울'];
  final colors = ['빨강', '파랑', '초록', '노랑', '검정', '흰색', '회색', '보라', '베이지', '갈색'];
  final styles = ['캐주얼', '포멀', '스포티', '트렌디', '빈티지', '모던'];
  final purposes = ['일상', '운동', '여행', '파티', '출근', '데이트'];

  String selectedSection = '카테고리';

  String? filterCategory;
  String? filterSeason;
  String? filterColor;
  String? filterStyle;
  String? filterPurpose;

  return await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          List<String> currentOptions;
          String? selectedOption;

          switch (selectedSection) {
            case '카테고리':
              currentOptions = categories;
              selectedOption = filterCategory;
              break;
            case '계절':
              currentOptions = seasons;
              selectedOption = filterSeason;
              break;
            case '색상':
              currentOptions = colors;
              selectedOption = filterColor;
              break;
            case '스타일':
              currentOptions = styles;
              selectedOption = filterStyle;
              break;
            case '용도':
              currentOptions = purposes;
              selectedOption = filterPurpose;
              break;
            default:
              currentOptions = [];
              selectedOption = null;
          }

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
                          filterCategory = null;
                          filterSeason = null;
                          filterColor = null;
                          filterStyle = null;
                          filterPurpose = null;
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
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final section =
                              ['카테고리', '계절', '색상', '스타일', '용도'][index];
                          final isSelected = selectedSection == section;

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
                                final isSelected = selectedOption == option;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      switch (selectedSection) {
                                        case '카테고리':
                                          filterCategory =
                                              isSelected ? null : option;
                                          break;
                                        case '계절':
                                          filterSeason =
                                              isSelected ? null : option;
                                          break;
                                        case '색상':
                                          filterColor =
                                              isSelected ? null : option;
                                          break;
                                        case '스타일':
                                          filterStyle =
                                              isSelected ? null : option;
                                          break;
                                        case '용도':
                                          filterPurpose =
                                              isSelected ? null : option;
                                          break;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
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
                                final isSelected = selectedOption == option;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      switch (selectedSection) {
                                        case '카테고리':
                                          filterCategory =
                                              isSelected ? null : option;
                                          break;
                                        case '계절':
                                          filterSeason =
                                              isSelected ? null : option;
                                          break;
                                        case '색상':
                                          filterColor =
                                              isSelected ? null : option;
                                          break;
                                        case '스타일':
                                          filterStyle =
                                              isSelected ? null : option;
                                          break;
                                        case '용도':
                                          filterPurpose =
                                              isSelected ? null : option;
                                          break;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
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
                      'filterCategory': filterCategory,
                      'filterSeason': filterSeason,
                      'filterColor': filterColor,
                      'filterStyle': filterStyle,
                      'filterPurpose': filterPurpose,
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
