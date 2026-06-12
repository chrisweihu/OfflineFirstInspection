part of 'image_list_cubit.dart';

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
