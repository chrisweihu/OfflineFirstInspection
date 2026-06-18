import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/core/usecase/usecase.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/usecases/get_all_inspection_forms.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/usecases/sync_inspection_forms.dart';
import 'package:offline_first_inspection/init_dependencies.dart';

@immutable
sealed class InspectionTableState {}

final class InspectionTableInitialState extends InspectionTableState {}

final class InspectionTableLoadingState extends InspectionTableState {}

final class InspectionTableFailureState extends InspectionTableState {
  final String error;
  InspectionTableFailureState(this.error);
}

typedef TableRowData = ({
  String id,
  String inspector,
  String status,
  DateTime? date,
  String summary,
});

final class InspectionTableLoadedState extends InspectionTableState {
  final List<InspectionFormDto> data;
  InspectionTableLoadedState({required this.data});
}

class InspectionTableNotifier extends Notifier<InspectionTableState> {
  late final GetAllLocalInspectionForms _getAllLocalInspectionForms;
  late final SyncInspectionForms _syncInspectionForms;

  @override
  InspectionTableState build() {
    _getAllLocalInspectionForms = getIt<GetAllLocalInspectionForms>();
    _syncInspectionForms = getIt<SyncInspectionForms>();
    return InspectionTableInitialState();
  }

  Future<void> syncInspectionForms() async {
    state = InspectionTableLoadingState();

    final Either<Failure, List<InspectionFormDto>> res = await _syncInspectionForms(NoParams());

    res.fold(
      (l) => state = InspectionTableFailureState(l.message),
      (r) => state = InspectionTableLoadedState(data: r),
    );
  }

  Future<void> loadInspectionForms() async {
    final Either<Failure, List<InspectionFormDto>> res = await _getAllLocalInspectionForms(NoParams());

    res.fold(
      (l) => state = InspectionTableFailureState(l.message),
      (r) => state = InspectionTableLoadedState(data: r),
    );
  }
}

final inspectionTableProvider = NotifierProvider<InspectionTableNotifier, InspectionTableState>(
  InspectionTableNotifier.new,
);
