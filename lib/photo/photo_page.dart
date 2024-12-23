import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_board/photo/photo_category_tag_popup.dart';
import 'photo_page_cubit.dart';
import 'photo_page_state.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  @override
  void initState() {
    super.initState();
    context.read<PhotoPageCubit>().loadUserPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    final pickedFile =
                        await context.read<PhotoPageCubit>().takePhoto();

                    if (pickedFile != null) {
                      final categoryTagData = await showCategoryTagPopup(
                          context, File(pickedFile.path));

                      if (categoryTagData != null) {
                        final category = categoryTagData['category'] as String;
                        final tags =
                            categoryTagData['tags'] as Map<String, String?>;

                        context.read<PhotoPageCubit>().savePhotoWithDetails(
                              filePath: pickedFile.path,
                              category: category,
                              tags: tags,
                            );
                      }
                    }
                  },
                  child: const Text('사진 찍기'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    final pickedFile = await context
                        .read<PhotoPageCubit>()
                        .pickPhotoFromGallery();

                    if (pickedFile != null) {
                      final categoryTagData = await showCategoryTagPopup(
                        context,
                        File(pickedFile.path),
                      );

                      if (categoryTagData != null) {
                        final category = categoryTagData['category'] as String;
                        final tags =
                            categoryTagData['tags'] as Map<String, String?>;

                        await context
                            .read<PhotoPageCubit>()
                            .savePhotoWithDetails(
                              filePath: pickedFile.path,
                              category: category,
                              tags: tags,
                            );
                      }
                    }
                  },
                  child: const Text('갤러리에서 가져오기'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PhotoPageCubit, PhotoPageState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.8,
                    ),
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    itemCount: state.photoPaths.length,
                    itemBuilder: (context, index) {
                      final category = state.photoCategories[index];
                      final tags = state.photoTags[index];

                      return Column(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(state.photoPaths[index]),
                                  width: 300,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Chip(
                                  label: Text(
                                    tags['season']!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: const Color(0xFF333333),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Chip(
                                  label: Text(
                                    tags['color']!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: const Color(0xFF333333),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Chip(
                                  label: Text(
                                    tags['style']!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: const Color(0xFF333333),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Chip(
                                  label: Text(
                                    tags['purpose']!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: const Color(0xFF333333),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
