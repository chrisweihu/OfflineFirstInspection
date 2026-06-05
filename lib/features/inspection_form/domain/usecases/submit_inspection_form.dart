import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/core/usecase/usecase.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/repositories/inspection_form_repository.dart';

class SubmitInspectionForm
    implements IUseCase<InspectionFormDto, InspectionFormDto> {
  final IInspectionFormRepository repo;

  SubmitInspectionForm({required this.repo});

  @override
  Future<Either<Failure, InspectionFormDto>> call(
    InspectionFormDto params,
  ) async {
    final res = await repo.submitLocalInspectionForm(dto: params);
    return res;
  }
}
