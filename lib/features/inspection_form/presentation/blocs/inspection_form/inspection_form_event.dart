part of 'inspection_form_bloc.dart';

@immutable
sealed class InspectionFormEvent {}

class InspectionFormSubmitEvent extends InspectionFormEvent {
  final InspectionFormDto data;

  InspectionFormSubmitEvent({required this.data});
}
