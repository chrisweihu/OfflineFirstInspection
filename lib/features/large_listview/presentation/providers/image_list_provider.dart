import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_inspection/features/large_listview/data/dtos/photo_dto.dart';

@immutable
sealed class ImageListState {}

final class ImageListInitialState extends ImageListState {}

final class ImageListLoadedState extends ImageListState {
  final List<PhotoDto> images;

  ImageListLoadedState({required this.images});
}

final class ImageListFailedState extends ImageListState {
  final String error;

  ImageListFailedState({required this.error});
}

class ImageListNotifier extends AutoDisposeNotifier<ImageListState> {
  @override
  ImageListState build() {
    return ImageListInitialState();
  }

  Future<void> loadImages() async {
    try {
      final List<PhotoDto> photos = await _loadDataAsync();
      state = ImageListLoadedState(images: photos);
    } catch (e) {
      state = ImageListFailedState(error: "Failed to load image list. ${e.toString()}");
    }
  }

  /// This is a mock method to fake network API call to load and deserialize large list of photo objects.
  /// and it uses free web service "https://picsum.photos" to display network images in our ListView
  Future<List<PhotoDto>> _loadDataAsync() async {
    // Simulate massive JSON payload
    final String mockJson = List.generate(
      2000,
      (i) => '{"id": $i, "title": "Image $i", "url": "https://picsum.photos"}',
    ).toString();

    final photos = await compute(parsePhotosInIsolate, mockJson);
    return photos;
  }

  /// Offload Deserializing Json in a separate isolate so the UI never stutters during JSON parsing.
  static Future<List<PhotoDto>> parsePhotosInIsolate(String jsonString) async {
    //Fake 1s delay for heavy json parsing work
    await Future.delayed(const Duration(seconds: 1));

    final parsed = jsonDecode(jsonString);
    return parsed.map<PhotoDto>((json) => PhotoDto.fromJson(json)).toList();
  }
}

final imageListProvider = NotifierProvider.autoDispose<ImageListNotifier, ImageListState>(
  ImageListNotifier.new,
);
