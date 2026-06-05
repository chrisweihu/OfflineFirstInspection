part of 'inspection_table_bloc.dart';

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
