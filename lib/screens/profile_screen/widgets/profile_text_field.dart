import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProfileTextField extends StatefulWidget {
  TextEditingController controller;
  String label;
  bool enabled;
  String? Function(String?)? validator;
  bool isEditMode;

  ProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    this.enabled = true,
    this.validator,
    required this.isEditMode,
  });

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.isEditMode && widget.enabled,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[900] ?? Colors.grey),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        labelText: widget.label,
      ),
      validator: widget.validator,
    );
  }
}
