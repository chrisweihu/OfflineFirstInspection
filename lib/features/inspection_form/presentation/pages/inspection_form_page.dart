import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_inspection/core/common/widgets/loader.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/blocs/inspection_form/inspection_form_bloc.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/cubits/form_field/form_checkbox_cubit.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/widgets/inspection_checkbox_field.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/widgets/inspection_date_field.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/widgets/inspection_dropdown_field.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/widgets/inspection_text_field.dart';
import 'package:offline_first_inspection/init_dependencies.dart';

class InspectionFormPage extends StatefulWidget {
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
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<InspectionFormBloc>()),
        BlocProvider(create: (context) => getIt<FormCheckboxCubit>()),
      ],
      child: InspectionFormPage(formData: formData, mode: mode),
    ),
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
  State<InspectionFormPage> createState() => _InspectionFormPageState();
}

class _InspectionFormPageState extends State<InspectionFormPage> {
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
    return BlocBuilder<InspectionFormBloc, InspectionFormState>(
      builder: (context, state) {
        return switch (state) {
          InspectionFormFailureState() => Text('Failed to load form: $state.'),
          InspectionFormLoadingState() => const Loader(),
          _ => buildPageScaffold(state, context),
        };
      },
    );
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

                  context.read<InspectionFormBloc>().add(
                    InspectionFormSubmitEvent(data: _formData),
                  );
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
                crossAxisAlignment: .start,
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
                  BlocBuilder<FormCheckboxCubit, FormCheckboxState>(
                    // return true/false to determine whether or not to rebuild the widget with state
                    buildWhen: (previousState, state) {
                      return (state is FormCheckboxUpdatedState &&
                          state.fieldId ==
                              InspectionFormPage.fidReviewRequired);
                    },
                    builder: (context, state) {
                      return (state is FormCheckboxUpdatedState && state.value)
                          ? InspectionTextField(
                              initialValue: _formData.reviewDescription,
                              controller:
                                  _reviewDesController, //only controller can retain the text value in rebuild
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
                  BlocBuilder<FormCheckboxCubit, FormCheckboxState>(
                    // return true/false to determine whether or not to rebuild the widget with state
                    buildWhen: (previousState, state) {
                      return (state is FormCheckboxUpdatedState &&
                          state.fieldId ==
                              InspectionFormPage.fidActionRequired);
                    },
                    builder: (context, state) {
                      return (state is FormCheckboxUpdatedState && state.value)
                          ? InspectionTextField(
                              initialValue: _formData.actionDescription,
                              controller:
                                  _actionDesController, //only controller can retain the text value in rebuild
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
