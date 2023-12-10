import 'package:flutter/material.dart';

class RailwayTextField extends StatefulWidget {
  String label;
  bool enabled;
  bool visible;
  String? Function(String?)? validator;
  bool isEditMode;
  final onTap;
  final onSaved;
  bool? readOnly;
  String initVal;
  int maxLines;

  RailwayTextField({
    Key? key,
    required this.label,
    this.enabled = true,
    this.visible = true,
    this.maxLines = 1,
    this.validator,
    this.readOnly,
    required this.isEditMode,
    this.onTap,
    this.initVal = "",
    this.onSaved,
  }) : super(key: key);

  @override
  State<RailwayTextField> createState() => _RailwayTextFieldState();
}

class _RailwayTextFieldState extends State<RailwayTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 4, 5),
      child: Column(
        children: [
          TextFormField(
            readOnly: widget.readOnly ?? false,
            enabled: widget.isEditMode && widget.enabled,
            maxLines: widget.maxLines, // Set the max lines property
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              labelStyle: const TextStyle(
                color: Colors.grey,
              ),
              labelText: widget.label,
            ),
            onTap: widget.onTap ?? () {},
            onChanged: widget.onSaved ?? (val) {},
            validator: widget.validator,
            initialValue: widget.initVal,
          ),
        ],
      ),
    );
  }
}
