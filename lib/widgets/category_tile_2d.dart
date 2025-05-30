import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/styling/styling_page_cubit.dart';
import 'package:style_board/styling/styling_page_state.dart';

class CategoryTile2D extends StatelessWidget {
  final String category;

  const CategoryTile2D({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StylingPageCubit, StylingPageState>(
      builder: (context, state) {
        final representativePhoto = state.selectedPhotos[category];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) {
                    final cubit = context.read<StylingPageCubit>();
                    cubit.loadPhotosByCategory(category);
                    return FractionallySizedBox(
                      heightFactor: 0.6,
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 5,
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          BlocBuilder<StylingPageCubit, StylingPageState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return const Expanded(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }

                              if (state.categoryPhotos.isEmpty) {
                                return const Expanded(
                                  child: Center(child: Text('저장된 사진이 없습니다.')),
                                );
                              }

                              return Expanded(
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: state.categoryPhotos.length,
                                  itemBuilder: (context, index) {
                                    final photo = state.categoryPhotos[index];
                                    return GestureDetector(
                                      onTap: () {
                                        cubit.selectPhoto(
                                            category: category, photo: photo);
                                        Navigator.pop(context);
                                      },
                                      child: _buildImage(photo),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: representativePhoto != null
                        ? _buildImage(representativePhoto)
                        : Icon(
                            Icons.add_a_photo,
                            color: Theme.of(context).colorScheme.primary,
                            size: MediaQuery.of(context).size.width * 0.1,
                          ),
                  ),
                  if (representativePhoto != null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          context
                              .read<StylingPageCubit>()
                              .removePhoto(category);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).colorScheme.surface,
                            size: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(url, fit: BoxFit.fill),
    );
  }
}
