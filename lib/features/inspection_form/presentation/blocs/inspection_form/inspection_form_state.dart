part of 'inspection_form_bloc.dart';

@immutable
sealed class InspectionFormState {}

final class InspectionFormInitialState extends InspectionFormState {}

final class InspectionFormLoadingState extends InspectionFormState {}

final class InspectionFormSubmittedState extends InspectionFormState {
  final InspectionFormDto data;

  InspectionFormSubmittedState({required this.data});
}

final class InspectionFormFailureState extends InspectionFormState {
  final String error;
  InspectionFormFailureState(this.error);
}
