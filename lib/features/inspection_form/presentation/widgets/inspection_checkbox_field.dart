import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/cubits/form_field/form_checkbox_cubit.dart';

class InspectionCheckboxField extends StatefulWidget {
  const InspectionCheckboxField({
    super.key,
    required this.label,
    this.checked = false,
    required this.onSaved,
  });
  final String label;
  final bool checked;
  final void Function(bool?) onSaved;
  @override
  State<InspectionCheckboxField> createState() =>
      _InspectionCheckboxFieldState();
}

class _InspectionCheckboxFieldState extends State<InspectionCheckboxField> {
  // 'late' allows us to access 'widget' because initialization
  // is deferred until the first time the variable is read.
  late bool _checked = widget.checked;

  // WidgetStateProperty allows for $O(1)$ lookup of property values during the build phase
  // WidgetStateProperty is evaluated during the Build phase. Because we mark this as static const,
  // the thumbIcon map is canonicalized at compile-time. This reduces the memory footprint on the Heap and
  // ensures that when the Element Tree notifies the RenderObject of a state change,
  // the lookup of the new Icon is virtually free, avoiding any unnecessary allocations
  // during the frame paint.
  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      });

  @override
  void initState() {
    super.initState();
    context.read<FormCheckboxCubit>().toggle(
      value: _checked,
      fieldId: widget.label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: _checked,
      onSaved: widget.onSaved,
      builder: (FormFieldState<bool> state) {
        return Column(
          spacing: 6,
          crossAxisAlignment: .start,
          children: [
            Text(widget.label, style: const TextStyle(fontWeight: .bold)),
            Switch(
              thumbIcon: thumbIcon,
              value: _checked,
              onChanged: (bool value) {
                _checked = value;
                state.didChange(_checked); // Updates the FormField state
                context.read<FormCheckboxCubit>().toggle(
                  value: _checked,
                  fieldId: widget.label,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
