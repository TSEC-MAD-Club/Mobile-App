// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProfileTextField extends StatefulWidget {
  // TextEditingController controller;
  String label;
  bool enabled;
  bool visible;
  String? Function(String?)? validator;
  bool isEditMode;
  final onTap;
  final onSaved;
  bool? readOnly;
  String initVal;

  ProfileTextField({
    Key? key,
    // required this.controller,
    required this.label,
    this.enabled = true,
    this.visible = true,
    this.validator,
    this.readOnly,
    required this.isEditMode,
    this.onTap,
    this.initVal = "",
    this.onSaved,
  }) : super(key: key);

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 4, 5),
      child: Column(
        children: [
          TextFormField(
            readOnly: widget.readOnly ?? false,
            // controller: widget.controller,
            enabled: widget.isEditMode && widget.enabled,
            // onChanged: (val) {
            //   widget.controller.text = val;
            // },
            // initialValue: widget.initVal,
            // onSaved: widget.onSaved,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ), // Change to your desired color
              ),
              disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary)),
              labelStyle: const TextStyle(
                color: Colors.grey,
              ),
              labelText: widget.label,
            ),
            style: TextStyle(
              color: widget.enabled
                  ? Theme.of(context).colorScheme.onSecondaryContainer
                  : Theme.of(context)
                      .colorScheme
                      .onSecondaryContainer
                      .withOpacity(0.4),
            ),
            onTap: widget.onTap ?? () {},
            onChanged: widget.onSaved ?? (val) {},
            validator: widget.validator,
            initialValue: widget.initVal,
            // onSaved: widget.onSaved ?? (val) {},
          ),
          // Divider(
          //   thickness: 1,
          //   color: Color(0xFF454545),
          // ),
        ],
      ),
    );
  }
}
