import 'package:flutter/material.dart';

class AppFormField extends StatelessWidget {
  const AppFormField({
    super.key,
    this.label,
    this.readOnly = false,
    this.hint,
    this.ctr,
    this.onTap,
    this.validator,
    this.isOutsideLabel = false,
    this.maxLines,
    this.minLines = 1,
  });
  const AppFormField.label({
    super.key,
    this.label,
    this.onTap,
    this.readOnly = false,
    this.hint,
    this.ctr,
    this.validator,
    this.isOutsideLabel = true,
    this.maxLines,
    this.minLines = 1,
  }) : assert(
         isOutsideLabel == true || label != null,
         "If isOutsideLabel is false, label must not be null",
       );
  final bool isOutsideLabel, readOnly;
  final String? label;
  final String? hint;
  final TextEditingController? ctr;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int minLines;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isOutsideLabel && label != null) AppLabel(label: label),
        TextFormField(
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines ?? minLines,
          minLines: minLines,
          decoration: InputDecoration(
            label: (label != null && !isOutsideLabel) ? Text(label!) : null,
            hintText: hint,
          ),
          controller: ctr,
          validator: validator,
        ),
      ],
    );
  }
}

class AppLabel extends StatelessWidget {
  const AppLabel({super.key, required this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(label!, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}
