import 'package:flutter/material.dart';

class RailwayDropdownField extends StatelessWidget {
  bool editMode;
  String label;
  String? val;
  String? Function(String?)? validator;
  final onChanged;
  List<String> items;

  RailwayDropdownField(
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
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primaryContainer, // Set the background color
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: editMode
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.outline,
            width: .5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
          child: DropdownButtonFormField(
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
            // style: Theme.of(context).textTheme.bodySmall,
            value: val,
            validator: validator,
            decoration: InputDecoration(
              iconColor: Colors.white,
              border: InputBorder.none,
              labelStyle: const TextStyle(
                color: Colors.grey,
              ),
              labelText: label,
            ),
            icon: const Icon(Icons.keyboard_arrow_down),

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
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
