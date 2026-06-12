import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_inspection/core/common/widgets/loader.dart';
import 'package:offline_first_inspection/features/large_listview/data/dtos/photo_dto.dart';
import 'package:offline_first_inspection/features/large_listview/presentation/cubit/image_list/image_list_cubit.dart';

class OptimizedImageListScreen extends StatefulWidget {
  static MaterialPageRoute<OptimizedImageListScreen> route() => MaterialPageRoute(builder: (_) => const OptimizedImageListScreen());

  const OptimizedImageListScreen({super.key});
  @override
  State<OptimizedImageListScreen> createState() => _OptimizedImageListScreenState();
}

class _OptimizedImageListScreenState extends State<OptimizedImageListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ImageListCubit>().loadImages();
  }

  @override
  void dispose() {
    _clearMemory();
    super.dispose();
  }

  //Clear the cache manually if we need to free up memory immediately (e.g., when the user leaves a large gallery screen),
  void _clearMemory() {
    // Clears all pending and completed images from the cache
    PaintingBinding.instance.imageCache.clear();

    // Clears images currently being displayed (live references) only for HotReload purpose
    if (kDebugMode) {
      PaintingBinding.instance.imageCache.clearLiveImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fast Scrolling Image List')),
      body: BlocBuilder<ImageListCubit, ImageListState>(
        builder: (context, state) {
          return switch (state) {
            ImageListInitialState() => const Loader(),
            ImageListLoadedState(images: final photos) => _imageListView(photos),
            ImageListFailedState(error: final message) => Text(message),
          };
        },
      ),
    );
  }

  ListView _imageListView(List<PhotoDto> photos) {
    return ListView.builder(
      itemCount: photos.length,
      itemExtent: 90.0, // Fixed height for instant scroll calculations
      itemBuilder: (context, index) {
        final photo = photos[index];

        return ListTile(
          key: ValueKey(photo.id), // Key for element reuse
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),

            child: Image.network(
              '${photo.url}/${120 + photo.id}',
              width: 100,
              height: 100,
              fit: BoxFit.fill,
              // 3. NATIVE IMAGE CACHING & DECODING OPTIMIZATION
              // This is the "magic" property. It decodes the image to exactly 120px
              // width (assuming 2.0 device pixel ratio) instead of full size.
              cacheWidth: 120,
              cacheHeight: 120,

              // frameBuilder: Handles the Transition	| Triggers once bytes are decoded.
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                // If image is already in memory/cache, show it immediately
                if (wasSynchronouslyLoaded) return child;

                // Once frame is available, usually first frame value is 0, fade it in
                // Implicit Animations (like AnimatedOpacity) work by interpolating between an old value and a new value.
                // If the widget didn't exist in the tree with opacity: 0 before the image loaded,
                // if there is no "old value" to animate from, then the animation directly jumps to 1 opacity.
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.linear,
                  child: child,
                );
              },

              // Handles network errors gracefully
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 60),
            ),
          ),
          title: Text('${photo.title} : ${photo.id}'),
          subtitle: const Text('Decoded at UI resolution'),
        );
      },
    );
  }
}
