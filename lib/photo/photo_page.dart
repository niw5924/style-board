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
                    context.read<PhotoPageCubit>().takePhoto();
                  },
                  child: const Text('사진 찍기'),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 한 줄에 세 개의 항목
                      crossAxisSpacing: 8.0, // 가로 간격
                      mainAxisSpacing: 8.0, // 세로 간격
                      childAspectRatio: 0.8, // 이미지 + 텍스트 비율 조정
                    ),
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.photoPaths.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4, // 전체 셀에서 4/5 높이 차지
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(state.photoPaths[index]),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            flex: 1, // 전체 셀에서 1/5 높이 차지
                            child: Center(
                              child: Text(
                                '사진 ${index + 1}',
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis, // 텍스트 오버플로우 처리
                              ),
                            ),
                          ),
                        ],
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
