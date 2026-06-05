part of 'inspection_table_bloc.dart';

@immutable
sealed class InspectionTableEvent {}

final class InspectionTableLoadEvent extends InspectionTableEvent {}

final class InspectionTableSyncEvent extends InspectionTableEvent {}
