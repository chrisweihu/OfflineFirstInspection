import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_inspection/core/common/widgets/loader.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/providers/inspection_form_provider.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/providers/form_checkbox_provider.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/widgets/inspection_checkbox_field.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/widgets/inspection_date_field.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/widgets/inspection_dropdown_field.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/widgets/inspection_text_field.dart';

class InspectionFormPage extends ConsumerStatefulWidget {
  static const fidInspectionStatus = 'Inspection Status';
  static const fidInspectionDate = 'Inspection Date';
  static const fidSummary = 'Summary';
  static const fidReviewRequired = 'Review Required';
  static const fidReviewDescription = 'Review Description';
  static const fidActionRequired = 'Action Required';
  static const fidActionDescription = 'Action Description';
  static const fidInspector = 'Inspector';

  static MaterialPageRoute<InspectionFormPage> route({
    required InspectionFormDto formData,
    required String mode,
  }) => MaterialPageRoute(
    builder: (context) => InspectionFormPage(formData: formData, mode: mode),
  );

  const InspectionFormPage({
    super.key,
    required InspectionFormDto formData,
    required String mode,
  }) : _formData = formData,
       _mode = mode;

  final InspectionFormDto _formData;
  final String _mode;
  @override
  ConsumerState<InspectionFormPage> createState() => _InspectionFormPageState();
}

class _InspectionFormPageState extends ConsumerState<InspectionFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final InspectionFormDto _formData;
  late final String _initialMode;
  late final TextEditingController _actionDesController;
  late final TextEditingController _reviewDesController;

  @override
  void initState() {
    super.initState();
    _initialMode = widget._mode;
    _formData = widget._formData;
    _actionDesController = TextEditingController();
    _reviewDesController = TextEditingController();
  }

  @override
  void dispose() {
    _reviewDesController.dispose();
    _actionDesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inspectionFormProvider);

    return switch (state) {
      InspectionFormFailureState() => Text('Failed to load form: $state.'),
      InspectionFormLoadingState() => const Loader(),
      _ => buildPageScaffold(state, context),
    };
  }

  Scaffold buildPageScaffold(InspectionFormState state, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${state is InspectionFormSubmittedState ? 'View' : _initialMode} Inspection',
        ),
        actions: [
          if (_initialMode != 'View' && state is InspectionFormInitialState)
            ElevatedButton.icon(
              onPressed: () {
                // 1. Remove Focus (Hides keyboard)
                // This is the functional equivalent of unfocusing the entire Page in MAUI.
                FocusScopeNode currentFocus = FocusScope.of(
                  context,
                  createDependency: false,
                );

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }

                // 2. Validate and Process
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState!.save();
                  // Execute Domain/Data layer logic here
                  if (kDebugMode) {
                    debugPrint(
                      'Form Submitted Successfully\n$InspectionFormDto',
                    );
                  }

                  ref.read(inspectionFormProvider.notifier).submitInspectionForm(_formData);
                }
              },
              label: const Text('Save'),
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          //use AbsorbPointer to disable entire form when it is in 'view' mode
          child: AbsorbPointer(
            absorbing:
                (state is InspectionFormSubmittedState ||
                    _initialMode == 'View')
                ? true
                : false,
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InspectionTextField(
                    onSaved: (val) =>
                        _formData.inspector = val ?? _formData.inspector,
                    initialValue: _formData.inspector,
                    label: InspectionFormPage.fidInspector,
                    hintText: 'email',
                    isRequired: true,
                  ),
                  InspectionDropdownField(
                    onSaved: (val) =>
                        _formData.status = val ?? _formData.status,
                    initialValue: _formData.status,
                    label: InspectionFormPage.fidInspectionStatus,
                    isRequired: true,
                  ),
                  InspectionDateField(
                    onSaved: (val) => _formData.date = val ?? _formData.date,
                    label: InspectionFormPage.fidInspectionDate,
                    isRequired: true,
                    initialValue: _formData.date,
                  ),
                  InspectionTextField(
                    onSaved: (val) =>
                        _formData.summary = val ?? _formData.summary,
                    initialValue: _formData.summary,
                    label: InspectionFormPage.fidSummary,
                    maxLines: 4,
                  ),
                  InspectionCheckboxField(
                    onSaved: (val) {
                      _formData.reviewRequired =
                          val ?? _formData.reviewRequired;
                    },
                    label: InspectionFormPage.fidReviewRequired,
                    checked: _formData.reviewRequired,
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final checkboxState = ref.watch(formCheckboxProvider);
                      final isSelected = checkboxState is FormCheckboxUpdatedState
                          ? (checkboxState.allValues[InspectionFormPage.fidReviewRequired] ?? false)
                          : _formData.reviewRequired;

                      return isSelected
                          ? InspectionTextField(
                              initialValue: _formData.reviewDescription,
                              controller: _reviewDesController, //only controller can retain the text value in rebuild
                              onSaved: (val) {
                                _formData.reviewDescription =
                                    val ?? _formData.reviewDescription;
                              },
                              label: InspectionFormPage.fidReviewDescription,
                              maxLines: 4,
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                  InspectionCheckboxField(
                    onSaved: (val) {
                      _formData.actionRequired =
                          val ?? _formData.actionRequired;
                    },
                    label: InspectionFormPage.fidActionRequired,
                    checked: _formData.actionRequired,
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final checkboxState = ref.watch(formCheckboxProvider);
                      final isSelected = checkboxState is FormCheckboxUpdatedState
                          ? (checkboxState.allValues[InspectionFormPage.fidActionRequired] ?? false)
                          : _formData.actionRequired;

                      return isSelected
                          ? InspectionTextField(
                              initialValue: _formData.actionDescription,
                              controller: _actionDesController, //only controller can retain the text value in rebuild
                              onSaved: (val) {
                                _formData.actionDescription =
                                    val ?? _formData.actionDescription;
                              },
                              label: InspectionFormPage.fidActionDescription,
                              maxLines: 4,
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
