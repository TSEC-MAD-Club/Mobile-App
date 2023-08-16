// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProfileTextField extends StatefulWidget {
  TextEditingController controller;
  String label;
  bool enabled;
  bool visible;
  String? Function(String?)? validator;
  bool isEditMode;

  ProfileTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.enabled = true,
    this.visible = true,
    this.validator,
    required this.isEditMode,
  }) : super(key: key);

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
        labelText: widget.label,
      ),
      validator: widget.validator,
    );
  }
}
