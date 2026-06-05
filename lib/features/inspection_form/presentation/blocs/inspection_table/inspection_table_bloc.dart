import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/core/usecase/usecase.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/usecases/get_all_inspection_forms.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/usecases/sync_inspection_forms.dart';

part 'inspection_table_event.dart';
part 'inspection_table_state.dart';

class InspectionTableBloc
    extends Bloc<InspectionTableEvent, InspectionTableState> {
  final GetAllLocalInspectionForms _getAllLocalInspectionForms;
  final SyncInspectionForms _syncInspectionForms;

  InspectionTableBloc({
    required GetAllLocalInspectionForms getAllInspectionForms,
    required SyncInspectionForms syncInspectionForms,
  }) : _syncInspectionForms = syncInspectionForms,
       _getAllLocalInspectionForms = getAllInspectionForms,
       super(InspectionTableInitialState()) {
    on<InspectionTableSyncEvent>((event, emit) async {
      emit(InspectionTableLoadingState());

      final Either<Failure, List<InspectionFormDto>> res =
          await _syncInspectionForms(NoParams());

      res.fold(
        (l) => emit(InspectionTableFailureState(l.message)),
        (r) => emit(InspectionTableLoadedState(data: r)),
      );
    });

    on<InspectionTableLoadEvent>((event, emit) async {
      final Either<Failure, List<InspectionFormDto>> res =
          await _getAllLocalInspectionForms(NoParams());

      res.fold(
        (l) => emit(InspectionTableFailureState(l.message)),
        (r) => emit(InspectionTableLoadedState(data: r)),
      );
    });
  }
}
