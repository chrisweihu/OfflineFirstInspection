import 'package:flutter/material.dart';

class InspectionDateField extends StatefulWidget {
  const InspectionDateField({
    super.key,
    required this.label,
    required this.onSaved,
    this.isRequired = false,
    this.initialValue,
  });

  final String label;
  final bool isRequired;
  final void Function(DateTime?) onSaved;
  final DateTime? initialValue;
  @override
  State<InspectionDateField> createState() => _InspectionDateFieldState();
}

class _InspectionDateFieldState extends State<InspectionDateField> {
  DateTime? _selectedDate;
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      crossAxisAlignment: .start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: .bold)),
        _buildFormField(),
      ],
    );
  }

  FormField<DateTime> _buildFormField() {
    return FormField<DateTime>(
      initialValue: _selectedDate,
      validator: (value) {
        if (value == null) {
          return 'required field: Please select a date';
        }
        return null;
      },
      onSaved: widget.onSaved,
      builder: (FormFieldState<DateTime> state) {
        return GestureDetector(
          onTap: () async {
            // Logic to pick a date
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (picked != null) {
              _selectedDate = picked;
              state.didChange(_selectedDate); // Updates the FormField state
            }
          },
          child: Column(
            crossAxisAlignment: .start,
            children: [
              //InputDecorator can be used to create widgets that look and behave like a TextField but support other kinds of input.
              InputDecorator(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(6),
                  // This automatically uses the Theme's InputDecorationTheme error color and style
                  errorText: state.errorText,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10),
                    Text(
                      _selectedDate == null
                          ? 'Please select a date'
                          : '${_selectedDate!.day} / ${_selectedDate!.month} / ${_selectedDate!.year}',
                    ),
                  ],
                ),
              ),
              // Manually display error text if not using InputDecorator
              // if (state.hasError)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 12, top: 8),
              //     child: Text(
              //       state.errorText!,
              //       style: TextStyle(
              //         color: Theme.of(context).colorScheme.error,
              //         fontSize: 12,
              //       ),
              //     ),
              //   ),
            ],
          ),
        );
      },
    );
  }
}
