import 'package:flutter/material.dart';

class NotesDropdownField extends StatelessWidget {
  bool editMode;
  String label;
  String? val;
  String? Function(String?)? validator;
  final onChanged;
  List<String> items;

  NotesDropdownField(
      {super.key,
      required this.editMode,
      required this.label,
      this.val,
      this.onChanged,
      required this.items,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 11, 20, 11),
      child: DropdownButtonFormField(
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white),
        // style: Theme.of(context).textTheme.bodySmall,
        value: val,
        validator: validator,
        decoration: InputDecoration(
          border: editMode ? UnderlineInputBorder() : InputBorder.none,
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          labelText: label,
        ),
        icon: editMode ? Icon(Icons.keyboard_arrow_down) : Icon(null),
        dropdownColor: Theme.of(context).colorScheme.background,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }).toList(),
        onChanged: editMode ? onChanged : null,
      ),
    );
  }
}
