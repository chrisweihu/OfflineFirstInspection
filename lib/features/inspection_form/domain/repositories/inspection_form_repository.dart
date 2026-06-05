import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';

abstract interface class IInspectionFormRepository {
  Future<Either<Failure, InspectionFormDto>> submitLocalInspectionForm({
    required InspectionFormDto dto,
  });

  Future<Either<Failure, List<InspectionFormDto>>> getAllLocalInspectionForms();
  Future<Either<Failure, List<InspectionFormDto>>> syncInspectionForms();
}
