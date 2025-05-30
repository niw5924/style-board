import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:style_board/styling/3d/styling_3d_page_cubit.dart';
import 'package:style_board/styling/3d/styling_3d_page_state.dart';

class CategoryTile3D extends StatelessWidget {
  final String category;

  const CategoryTile3D({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
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
        BlocBuilder<Styling3DPageCubit, Styling3DPageState>(
          builder: (context, state) {
            final glbUrl = state.glbUrls[category];
            final isLoading = state.isLoading[category] == true;
            final progress = state.progress[category];

            return Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: (isLoading && progress != null)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              '$progress%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : glbUrl != null
                          ? ModelViewer(
                              src: 'file://$glbUrl',
                              alt: 'A 3D model of $category',
                              ar: false,
                              autoRotate: false,
                              disableZoom: false,
                            )
                          : Icon(
                              Icons.threed_rotation,
                              color: Theme.of(context).colorScheme.primary,
                              size: MediaQuery.of(context).size.width * 0.1,
                            ),
                ),
                if (glbUrl != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<Styling3DPageCubit>()
                            .remove3DModel(category);
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
            );
          },
        ),
      ],
    );
  }
}
