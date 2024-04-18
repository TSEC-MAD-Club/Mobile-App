import 'package:flutter/material.dart';

class RailwayTextField extends StatelessWidget {
  bool editMode;
  String label;
  TextEditingController? controller;
  bool readOnly;
  String? val;
  int? maxLines;

  String? Function(String?)? validator;
  final onTap;
  RailwayTextField({
    super.key,
    this.validator,
    required this.editMode,
    required this.readOnly,
    required this.label,
    this.controller,
    this.val,
    this.maxLines,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primaryContainer, // Set the background color
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: editMode && !readOnly
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.outline,
            width: .5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
          child: TextFormField(
            style: Theme.of(context).textTheme.bodySmall,
            controller: controller,
            onTap: onTap,
            readOnly: readOnly,
            maxLines: maxLines,
            validator: validator,
            initialValue: val,
            enabled: editMode,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelStyle: const TextStyle(
                color: Colors.grey,
              ),
              labelText: label,
            ),
          ),
        ),
      ),
    );
  }
}
