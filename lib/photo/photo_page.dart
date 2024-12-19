import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: BlocBuilder<PhotoPageCubit, PhotoPageState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.errorMessage != null) {
            return Center(child: Text('오류: ${state.errorMessage}'));
          } else {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 사진 찍기 로직 실행
                    context.read<PhotoPageCubit>().takePhoto();
                  },
                  child: const Text('사진 찍기'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.photoPaths.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // 이미지 표시
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(state.photoPaths[index]),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16), // 간격
                            // 사진 제목 표시
                            Expanded(
                              child: Text(
                                '사진 ${index + 1}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
