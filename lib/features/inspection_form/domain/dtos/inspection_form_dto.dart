import 'package:json_annotation/json_annotation.dart';
import 'package:offline_first_inspection/core/common/enums/inspection_status.dart';
part 'inspection_form_dto.g.dart';

@JsonSerializable()
class InspectionFormDto {
  final String id;
  InspectionStatus? status;
  String inspector;
  DateTime? date;
  String summary;
  @JsonKey(name: 'review_required')
  bool reviewRequired;
  @JsonKey(name: 'review_description')
  String reviewDescription;
  @JsonKey(name: 'action_required')
  bool actionRequired;
  @JsonKey(name: 'action_description')
  String actionDescription;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool dirty;

  InspectionFormDto({
    required this.id,
    this.status = InspectionStatus.wip,
    this.inspector = '',
    this.date,
    this.summary = '',
    this.reviewRequired = false,
    this.reviewDescription = '',
    this.actionRequired = false,
    this.actionDescription = '',
    this.dirty = false,
  });

  factory InspectionFormDto.fromJson(Map<String, dynamic> json) =>
      _$InspectionFormDtoFromJson(json);
  Map<String, dynamic> toJson() => _$InspectionFormDtoToJson(this);

  // InspectionFormDto copyWith({
  //   String? id,
  //   InspectionStatus? status,
  //   String? inspector,
  //   DateTime? date,
  //   String? summary,
  //   bool? reviewRequired,
  //   String? reviewDescription,
  //   bool? actionRequired,
  //   String? actionDescription,
  // }) => InspectionFormDto(
  //   id: id ?? this.id,
  //   status: status ?? this.status,
  //   inspector: inspector ?? this.inspector,
  //   date: date ?? this.date,
  //   summary: summary ?? this.summary,
  //   reviewRequired: reviewRequired ?? this.reviewRequired,
  //   reviewDescription: reviewDescription ?? this.reviewDescription,
  //   actionRequired: actionRequired ?? this.actionRequired,
  //   actionDescription: actionDescription ?? this.actionDescription,
  // );
}
