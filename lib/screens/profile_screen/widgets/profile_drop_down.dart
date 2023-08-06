import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tsec_app/screens/department_screen/widgets/drop_down_menu_item.dart';
import 'package:tsec_app/utils/themes.dart';
import '../../../utils/themes.dart';

class ProfileDropDown extends StatefulWidget {
  TextEditingController controller;
  String label;
  String value;
  bool enabled;
  String? Function(String?)? validator;
  bool isEditMode;
  List options;
  ThemeMode theme;

  ProfileDropDown(
      {super.key,
      required this.controller,
      required this.label,
      this.enabled = true,
      this.validator,
      required this.isEditMode,
      required this.options,
      required this.value,
      required this.theme});

  @override
  State<ProfileDropDown> createState() => _ProfileDropDownState();
}

class _ProfileDropDownState extends State<ProfileDropDown> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !(widget.isEditMode && widget.enabled),
      child: DropdownButtonFormField(
        items: widget.options
            .map((option) => DropdownMenuItem(
                  child: Text(option.toString()),
                  value: option,
                ))
            .toList(),
        onChanged: (Object? value) {
          setState(() {
            value = value;
          });
        },
        value: widget.value,
        decoration: InputDecoration(
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelText: widget.label,
        ),
        dropdownColor:
            widget.theme.toString() == "ThemeMode.light" ? kWhite : kBlack,
      ),
    );
  }
}
