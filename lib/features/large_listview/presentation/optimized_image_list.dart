import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 1. DATA MODEL
class Photo {
  final int id;
  final String title;
  final String url;
  Photo({required this.id, required this.title, required this.url});

  factory Photo.fromJson(Map<String, dynamic> json) =>
      Photo(id: json['id'], title: json['title'], url: json['url']);
}

// 2. ISOLATE-BASED PARSING (Top-level function)
// This runs in a separate thread so the UI never stutters during JSON parsing.
List<Photo> parsePhotosInIsolate(String jsonString) {
  final List<dynamic> parsed = jsonDecode(jsonString);
  return parsed.map((json) => Photo.fromJson(json)).toList();
}

class OptimizedImageListScreen extends StatefulWidget {
  static MaterialPageRoute<OptimizedImageListScreen> route() =>
      MaterialPageRoute(builder: (_) => const OptimizedImageListScreen());

  const OptimizedImageListScreen({super.key});
  @override
  State<OptimizedImageListScreen> createState() =>
      _OptimizedImageListScreenState();
}

class _OptimizedImageListScreenState extends State<OptimizedImageListScreen> {
  List<Photo> _photos = [];
  bool _isLoading = true;

  ///If you need to free up memory immediately (e.g., when the user leaves a large gallery screen),
  ///you can clear the cache manually:
  void _clearMemory() {
    // Clears all pending and completed images from the cache
    PaintingBinding.instance.imageCache.clear();

    // Clears images currently being displayed (live references) only for HotReload purpose
    if (kDebugMode) {
      PaintingBinding.instance.imageCache.clearLiveImages();
    }
  }

  @override
  void dispose() {
    _clearMemory();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    /// This 'Fire and Forget' pattern is standard Flutter practice
    /// and is the correct way to trigger asynchronous work in initState() method
    /// when a widget is first created.
    _loadDataAsync();
  }

  Future<void> _loadDataAsync() async {
    // Simulated massive JSON payload
    final String mockJson = List.generate(
      2000,
      (i) => '{"id": $i, "title": "Image $i", "url": "https://picsum.photos"}',
    ).toString();

    //compute: Keeps the main thread entirely free for gestures and animations
    //         by Running heavy parsing in the background Isolate
    final photos = await compute(parsePhotosInIsolate, mockJson);

    /// IMPORTANT: ALWAYS check if the widget is still "mounted" before calling setState
    /// Because the _loadDataAsync() method continues running after initState finishes,
    /// the user might navigate away from the screen before the data finishes loading.
    /// If you call setState() on a widget that is no longer in the tree, your app will crash.
    if (mounted) {
      setState(() {
        _photos = photos;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fast Scrolling Image List')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _photos.length,
              itemExtent: 90.0, // Fixed height for instant scroll calculations
              itemBuilder: (context, index) {
                final photo = _photos[index];

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
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 60),
                    ),
                  ),
                  title: Text('${photo.title} : ${photo.id}'),
                  subtitle: const Text('Decoded at UI resolution'),
                );
              },
            ),
    );
  }
}
