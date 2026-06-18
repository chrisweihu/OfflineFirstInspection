import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
sealed class FormCheckboxState {}

final class FormCheckboxInitialState extends FormCheckboxState {}

final class FormCheckboxUpdatedState extends FormCheckboxState {
  final bool value;
  final String fieldId;
  final Map<String, bool> allValues;

  FormCheckboxUpdatedState({
    required this.value,
    required this.fieldId,
    required this.allValues,
  });
}

class FormCheckboxNotifier extends AutoDisposeNotifier<FormCheckboxState> {
  final Map<String, bool> _allValues = {};

  @override
  FormCheckboxState build() {
    return FormCheckboxInitialState();
  }

  void toggle({required bool value, required String fieldId}) {
    _allValues[fieldId] = value;
    state = FormCheckboxUpdatedState(
      value: value,
      fieldId: fieldId,
      allValues: Map.unmodifiable(_allValues),
    );
  }
}

final formCheckboxProvider = NotifierProvider.autoDispose<FormCheckboxNotifier, FormCheckboxState>(
  FormCheckboxNotifier.new,
);
