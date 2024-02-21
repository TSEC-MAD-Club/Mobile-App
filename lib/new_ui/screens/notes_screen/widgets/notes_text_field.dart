import 'package:flutter/material.dart';

class NotesTextField extends StatelessWidget {
  bool editMode;
  String label;
  TextEditingController? controller;
  bool readOnly;
  String? val;
  int? maxLines;

  String? Function(String?)? validator;
  final onTap;
  NotesTextField({
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
      padding: const EdgeInsets.fromLTRB(20, 11, 20, 11),
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
          // border: InputBorder.none,
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          labelText: label,
        ),
      ),
    );
  }
}
