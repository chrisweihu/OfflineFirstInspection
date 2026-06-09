// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_form_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionFormDto _$InspectionFormDtoFromJson(Map<String, dynamic> json) =>
    InspectionFormDto(
      id: json['id'] as String,
      status:
          $enumDecodeNullable(_$InspectionStatusEnumMap, json['status']) ??
          InspectionStatus.wip,
      inspector: json['inspector'] as String? ?? '',
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      summary: json['summary'] as String? ?? '',
      reviewRequired: json['review_required'] as bool? ?? false,
      reviewDescription: json['review_description'] as String? ?? '',
      actionRequired: json['action_required'] as bool? ?? false,
      actionDescription: json['action_description'] as String? ?? '',
      locationX: (json['location_x'] as num?)?.toDouble() ?? 0,
      locationY: (json['location_y'] as num?)?.toDouble() ?? 0,
      coordSystem:
          json['coord_system'] as String? ?? Constants.coordinateSystemWGS84,
    );

Map<String, dynamic> _$InspectionFormDtoToJson(InspectionFormDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$InspectionStatusEnumMap[instance.status],
      'inspector': instance.inspector,
      'date': instance.date?.toIso8601String(),
      'summary': instance.summary,
      'review_required': instance.reviewRequired,
      'review_description': instance.reviewDescription,
      'action_required': instance.actionRequired,
      'action_description': instance.actionDescription,
      'location_x': instance.locationX,
      'location_y': instance.locationY,
      'coord_system': instance.coordSystem,
    };

const _$InspectionStatusEnumMap = {
  InspectionStatus.wip: 'wip',
  InspectionStatus.draft: 'draft',
  InspectionStatus.authorized: 'authorized',
};
