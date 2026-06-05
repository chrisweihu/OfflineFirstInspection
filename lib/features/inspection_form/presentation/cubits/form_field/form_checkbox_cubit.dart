import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_checkbox_state.dart';

class FormCheckboxCubit extends Cubit<FormCheckboxState> {
  FormCheckboxCubit() : super(FormCheckboxInitialState());

  void toggle({required bool value, required String fieldId}) {
    emit(FormCheckboxUpdatedState(value: value, fieldId: fieldId));
  }
}
