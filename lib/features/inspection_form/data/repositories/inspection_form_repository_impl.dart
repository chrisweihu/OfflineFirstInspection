import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/core/network/connection_checker.dart';
import 'package:offline_first_inspection/features/inspection_form/data/datasources/inspection_form_local_data_source.dart';
import 'package:offline_first_inspection/features/inspection_form/data/datasources/inspection_form_remote_data_source.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/repositories/inspection_form_repository.dart';

class InspectionFormRepositoryImpl implements IInspectionFormRepository {
  final IInspectionFormRemoteDataSource remoteDataSource;
  final IInspectionFormLocalDataSource localDataSource;
  final IConnectionChecker connectionChecker;

  InspectionFormRepositoryImpl({
    required this.localDataSource,
    required this.connectionChecker,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<InspectionFormDto>>> syncInspectionForms() async {
    try {
      final res = await remoteDataSource.syncInspectionForms();
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InspectionFormDto>>>
  getAllLocalInspectionForms() async {
    try {
      final res = await localDataSource.getAllInspections();
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InspectionFormDto>> submitLocalInspectionForm({
    required InspectionFormDto dto,
  }) async {
    final res = await localDataSource.submitInspectionForm(
      dto: dto,
      markDirty: true,
    );
    return res;
  }
}
