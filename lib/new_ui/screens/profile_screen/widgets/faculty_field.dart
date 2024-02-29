import 'package:flutter/material.dart';

class FacultyField extends StatelessWidget {
  String labelName;
  TextEditingController? controller;
  bool enabled;
  bool? readOnly;
  String? value;
  final onChanged;
  String? Function(String?)? validator;
  final onTap;

  FacultyField({
    super.key,
    this.readOnly,
    required this.labelName,
    required this.enabled,
    this.value,
    this.onChanged,
    this.controller,
    this.validator,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: enabled
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Row(
          children: [
            Text(
              labelName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * .50,
              // height: MediaQuery.of(context).size.height * .0,
              // color: Colors.amber,
              child: TextFormField(
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    labelStyle: TextStyle(fontSize: 12)),
                enabled: enabled,
                controller: controller,
                readOnly: readOnly ?? false,
                initialValue: value,
                // style: Theme.of(context).textTheme.bodySmall,
                style: TextStyle(fontSize: 15, color: Colors.white),
                onChanged: onChanged,
                validator: validator,
                onTap: onTap,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
