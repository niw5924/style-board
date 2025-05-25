import 'package:flutter/material.dart';
import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:style_board/constants/closet_data.dart';

class ClosetFilterBottomSheet extends StatefulWidget {
  final String section;
  final String? filterCategory;
  final String? filterSeason;
  final String? filterColor;
  final String? filterStyle;
  final String? filterPurpose;

  const ClosetFilterBottomSheet({
    super.key,
    required this.section,
    required this.filterCategory,
    required this.filterSeason,
    required this.filterColor,
    required this.filterStyle,
    required this.filterPurpose,
  });

  @override
  State<ClosetFilterBottomSheet> createState() =>
      _ClosetFilterBottomSheetState();
}

class _ClosetFilterBottomSheetState extends State<ClosetFilterBottomSheet> {
  late String selectedSection;
  String? selectedCategory;
  String? selectedSeason;
  String? selectedColor;
  String? selectedStyle;
  String? selectedPurpose;

  final Map<String, List<String>> options = {
    '카테고리': categories,
    '계절': seasons,
    '색상': colors,
    '스타일': styles,
    '용도': purposes,
  };

  @override
  void initState() {
    super.initState();
    selectedSection = widget.section;
    selectedCategory = widget.filterCategory;
    selectedSeason = widget.filterSeason;
    selectedColor = widget.filterColor;
    selectedStyle = widget.filterStyle;
    selectedPurpose = widget.filterPurpose;
  }

  @override
  Widget build(BuildContext context) {
    final sectionHeight = MediaQuery.of(context).size.height * 0.3;
    final currentOptions = options[selectedSection]!;
    String? selectedOption;
    switch (selectedSection) {
      case '카테고리':
        selectedOption = selectedCategory;
        break;
      case '계절':
        selectedOption = selectedSeason;
        break;
      case '색상':
        selectedOption = selectedColor;
        break;
      case '스타일':
        selectedOption = selectedStyle;
        break;
      case '용도':
        selectedOption = selectedPurpose;
        break;
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    selectedCategory = null;
                    selectedSeason = null;
                    selectedColor = null;
                    selectedStyle = null;
                    selectedPurpose = null;
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
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: sectionHeight,
                  child: ListView.builder(
                    itemCount: options.keys.length,
                    itemBuilder: (context, index) {
                      final sectionKey = options.keys.elementAt(index);
                      final isSelected = selectedSection == sectionKey;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedSection = sectionKey);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: Text(
                            sectionKey,
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
              ),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: sectionHeight,
                  child: AutoHeightGridView(
                    itemCount: currentOptions.length,
                    crossAxisCount: currentOptions.length > 4 ? 2 : 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    padding: const EdgeInsets.all(8),
                    builder: (context, index) {
                      final option = currentOptions[index];
                      final isSelected = selectedOption == option;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            switch (selectedSection) {
                              case '카테고리':
                                selectedCategory = isSelected ? null : option;
                                break;
                              case '계절':
                                selectedSeason = isSelected ? null : option;
                                break;
                              case '색상':
                                selectedColor = isSelected ? null : option;
                                break;
                              case '스타일':
                                selectedStyle = isSelected ? null : option;
                                break;
                              case '용도':
                                selectedPurpose = isSelected ? null : option;
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
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade400,
                            ),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'filterCategory': selectedCategory,
                'filterSeason': selectedSeason,
                'filterColor': selectedColor,
                'filterStyle': selectedStyle,
                'filterPurpose': selectedPurpose,
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
  }
}
