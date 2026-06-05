import 'package:flutter/material.dart';
import 'package:offline_first_inspection/core/theme/theme.dart';

class InspectionTextField extends StatefulWidget {
  const InspectionTextField({
    super.key,
    required this.onSaved,
    required this.label,
    this.controller,
    this.isRequired = false,
    this.hintText,
    this.maxLines = 1,
    this.initialValue,
  });

  final void Function(String?) onSaved;
  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final bool isRequired;
  final int maxLines;
  final String? initialValue;

  @override
  State<InspectionTextField> createState() => _InspectionTextFieldState();
}

class _InspectionTextFieldState extends State<InspectionTextField> {
  late String? initialValue;
  @override
  void initState() {
    initialValue = widget.initialValue;
    if (initialValue != null) {
      if (widget.controller != null) {
        widget.controller!.text = initialValue!;
        initialValue = null;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      crossAxisAlignment: .start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: .bold)),
        TextFormField(
          initialValue: initialValue,
          onSaved: widget.onSaved,
          controller: widget.controller,
          maxLines: widget.maxLines,
          decoration: widget.hintText == null
              ? null
              : InputDecoration(
                  border: AppTheme.inputDecorationThemeData.border,
                  contentPadding: const .all(6),
                  hint: Text(
                    widget.hintText!,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 113, 112, 112),
                      fontStyle: .italic,
                    ),
                  ),
                ),
          validator: (value) {
            if (widget.isRequired && (value == null || value.isEmpty)) {
              return 'required field';
            }
            return null;
          },
        ),
      ],
    );
  }
}
