part of 'form_checkbox_cubit.dart';

@immutable
sealed class FormCheckboxState {}

final class FormCheckboxInitialState extends FormCheckboxState {}

final class FormCheckboxUpdatedState extends FormCheckboxState {
  final bool value;
  final String fieldId;

  FormCheckboxUpdatedState({required this.value, required this.fieldId});
}
