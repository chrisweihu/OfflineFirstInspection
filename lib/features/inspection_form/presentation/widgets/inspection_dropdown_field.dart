import 'package:flutter/material.dart';
import 'package:offline_first_inspection/core/common/enums/inspection_status.dart';

class InspectionDropdownField extends StatefulWidget {
  const InspectionDropdownField({
    super.key,
    //required this.controller,
    required this.label,
    required this.onSaved,
    this.isRequired = false,
    this.initialValue,
  });

  final InspectionStatus? initialValue;
  final String label;
  final bool isRequired;
  final void Function(InspectionStatus?) onSaved;

  @override
  State<InspectionDropdownField> createState() =>
      _InspectionDropdownFieldState();
}

class _InspectionDropdownFieldState extends State<InspectionDropdownField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      crossAxisAlignment: .start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: .bold)),
        DropdownMenuFormField<InspectionStatus>(
          initialSelection: widget.initialValue,
          expandedInsets: EdgeInsets.zero, // force it to expand to parent width
          validator: (value) {
            if (widget.isRequired && value == null) {
              return 'required field';
            }
            return null;
          },
          textStyle: Theme.of(context).textTheme.bodyMedium,
          dropdownMenuEntries: InspectionStatus.entires,
          // controller: widget.controller,
          onSaved: widget.onSaved,
          // decorationBuilder: (context, controller) {
          //   return const InputDecoration(contentPadding: .all(6));
          // },
        ),
      ],
    );
  }
}
