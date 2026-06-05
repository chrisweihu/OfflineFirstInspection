import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/core/usecase/usecase.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/repositories/inspection_form_repository.dart';

class SyncInspectionForms
    implements IUseCase<List<InspectionFormDto>, NoParams> {
  final IInspectionFormRepository repo;

  SyncInspectionForms({required this.repo});

  @override
  Future<Either<Failure, List<InspectionFormDto>>> call(params) async {
    final res = await repo.syncInspectionForms();
    return res;
  }
}
