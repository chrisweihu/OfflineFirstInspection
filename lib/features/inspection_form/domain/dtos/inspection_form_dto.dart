import 'package:json_annotation/json_annotation.dart';
import 'package:offline_first_inspection/core/common/enums/inspection_status.dart';
import 'package:offline_first_inspection/core/constants/constants.dart';
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
  @JsonKey(name: 'location_x')
  double locationX;
  @JsonKey(name: 'location_y')
  double locationY;
  @JsonKey(name: 'coord_system')
  String coordSystem;

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
    this.locationX = 0,
    this.locationY = 0,
    this.coordSystem = Constants.coordinateSystemWGS84,
  });

  factory InspectionFormDto.fromJson(Map<String, dynamic> json) => _$InspectionFormDtoFromJson(json);
  Map<String, dynamic> toJson() => _$InspectionFormDtoToJson(this);
}
