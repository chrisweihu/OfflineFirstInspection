// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoDto _$PhotoDtoFromJson(Map<String, dynamic> json) => PhotoDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$PhotoDtoToJson(PhotoDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'url': instance.url,
};
