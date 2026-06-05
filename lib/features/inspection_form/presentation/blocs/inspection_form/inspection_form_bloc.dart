import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/usecases/submit_inspection_form.dart';

part 'inspection_form_event.dart';
part 'inspection_form_state.dart';

class InspectionFormBloc
    extends Bloc<InspectionFormEvent, InspectionFormState> {
  final SubmitInspectionForm _submitInspectionForm;

  InspectionFormBloc({required SubmitInspectionForm submitInspectionForm})
    : _submitInspectionForm = submitInspectionForm,
      super(InspectionFormInitialState()) {
    on<InspectionFormEvent>(
      (event, emit) => emit(InspectionFormLoadingState()),
    );

    on<InspectionFormSubmitEvent>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1));
      final res = await _submitInspectionForm(event.data);
      res.fold(
        (l) => emit(InspectionFormFailureState(l.message)),
        (r) => emit(InspectionFormSubmittedState(data: event.data)),
      );
    });
  }
}
