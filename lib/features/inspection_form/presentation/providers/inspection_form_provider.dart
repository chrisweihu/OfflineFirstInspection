import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/usecases/submit_inspection_form.dart';
import 'package:offline_first_inspection/init_dependencies.dart';

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

class InspectionFormNotifier extends AutoDisposeNotifier<InspectionFormState> {
  late final SubmitInspectionForm _submitInspectionForm;

  @override
  InspectionFormState build() {
    _submitInspectionForm = getIt<SubmitInspectionForm>();
    return InspectionFormInitialState();
  }

  Future<void> submitInspectionForm(InspectionFormDto data) async {
    state = InspectionFormLoadingState();
    await Future.delayed(const Duration(seconds: 1));
    final res = await _submitInspectionForm(data);
    res.fold(
      (l) => state = InspectionFormFailureState(l.message),
      (r) => state = InspectionFormSubmittedState(data: data),
    );
  }
}

final inspectionFormProvider = NotifierProvider.autoDispose<InspectionFormNotifier, InspectionFormState>(
  InspectionFormNotifier.new,
);
