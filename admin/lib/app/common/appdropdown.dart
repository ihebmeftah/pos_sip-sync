import 'package:admin/app/common/appformfield.dart';
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    this.selectedItem,
    this.label,
    this.hint,
    this.onTap,
    this.validator,
    this.onChanged,
    this.isOutsideLabel = false,
    this.maxLines,
    required this.items,
  });
  const AppDropdown.label({
    super.key,
    this.selectedItem,
    this.label,
    this.onTap,
    this.hint,
    this.validator,
    this.onChanged,
    this.isOutsideLabel = true,
    this.maxLines,
    required this.items,
  }) : assert(
         isOutsideLabel == true || label != null,
         "If isOutsideLabel is false, label must not be null",
       );
  final bool isOutsideLabel;
  final String? label;
  final String? hint;
  final FormFieldValidator<T>? validator;
  final ValueChanged<T?>? onChanged;
  final int? maxLines;
  final VoidCallback? onTap;
  final List<DropdownMenuItem<T>> items;
  final T? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isOutsideLabel && label != null) AppLabel(label: label),
        DropdownButtonFormField<T>(
          isExpanded: true,
          initialValue: selectedItem,
          items: items,
          onChanged: onChanged,
          onTap: onTap,
          decoration: InputDecoration(
            label: (label != null && !isOutsideLabel) ? Text(label!) : null,
            hintText: hint,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
