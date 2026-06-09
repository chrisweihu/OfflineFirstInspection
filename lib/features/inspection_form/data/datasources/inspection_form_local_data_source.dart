import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/common/enums/inspection_status.dart';
import 'package:offline_first_inspection/core/error/exceptions.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/features/inspection_form/data/database.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';

abstract interface class IInspectionFormLocalDataSource {
  Future<Either<Failure, InspectionFormDto>> submitInspectionForm({required InspectionFormDto dto, required bool markDirty});
  Future<List<InspectionFormDto>> getAllInspections();
}

class InspectionFormLocalDataSourceImpl implements IInspectionFormLocalDataSource {
  InspectionFormLocalDataSourceImpl({required this.database});
  AppDatabase database;

  @override
  Future<List<InspectionFormDto>> getAllInspections() async {
    try {
      final allForms = await database.select(database.inspectionForms).get();
      List<InspectionFormDto> dtos = allForms
          .map(
            (e) => InspectionFormDto(
              id: e.id,
              status: InspectionStatus.values.asNameMap()[e.status],
              inspector: e.inspector,
              date: e.date,
              summary: e.summary,
              reviewRequired: e.reviewRequired,
              reviewDescription: e.reviewDescription,
              actionRequired: e.reviewRequired,
              actionDescription: e.actionDescription,
              dirty: e.dirty,
              locationX: e.locationX,
              locationY: e.locationY,
              coordSystem: e.coordSystem,
            ),
          )
          .toList();

      return dtos;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Either<Failure, InspectionFormDto>> submitInspectionForm({required InspectionFormDto dto, required bool markDirty}) async {
    try {
      //check if table record already exist
      final existing = await (database.select(database.inspectionForms)..where((r) => r.id.equals(dto.id))).getSingleOrNull();

      //insert or update
      if (existing == null) {
        await database
            .into(database.inspectionForms)
            .insert(
              InspectionFormsCompanion.insert(
                id: dto.id,
                status: dto.status?.name ?? '',
                inspector: dto.inspector,
                date: dto.date != null ? Value(dto.date) : const Value.absent(),
                summary: dto.summary,
                reviewRequired: dto.reviewRequired,
                reviewDescription: dto.reviewDescription,
                actionRequired: dto.actionRequired,
                actionDescription: dto.actionDescription,
                dirty: markDirty,
                locationX: dto.locationX,
                locationY: dto.locationY,
                coordSystem: dto.coordSystem,
              ),
            );
      } else {
        (database.update(database.inspectionForms)..where((r) => r.id.equals(existing.id))).write(
          InspectionFormsCompanion(
            status: Value(dto.status?.name ?? ''),
            inspector: Value(dto.inspector),
            date: dto.date != null ? Value(dto.date) : const Value.absent(),
            summary: Value(dto.summary),
            reviewRequired: Value(dto.reviewRequired),
            reviewDescription: Value(dto.reviewDescription),
            actionRequired: Value(dto.actionRequired),
            actionDescription: Value(dto.actionDescription),
            dirty: Value(markDirty),
            locationX: Value(dto.locationX),
            locationY: Value(dto.locationY),
            coordSystem: Value(dto.coordSystem),
          ),
        );
      }

      //return inserted/updated record converted in dto
      final updated = await (database.select(database.inspectionForms)..where((r) => r.id.equals(dto.id))).getSingleOrNull();

      if (updated == null) {
        return left(Failure('Unknow Error'));
      }

      return right(
        InspectionFormDto(
          id: updated.id,
          status: InspectionStatus.values.asNameMap()[updated.status],
          inspector: updated.inspector,
          date: updated.date,
          summary: updated.summary,
          reviewRequired: updated.reviewRequired,
          reviewDescription: updated.reviewDescription,
          actionRequired: updated.actionRequired,
          actionDescription: updated.actionDescription,
          dirty: updated.dirty,
          locationX: updated.locationX,
          locationY: updated.locationY,
          coordSystem: updated.coordSystem,
        ),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
