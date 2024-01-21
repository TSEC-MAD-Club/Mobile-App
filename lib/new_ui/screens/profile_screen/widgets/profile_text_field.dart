import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  String labelName;
  TextEditingController? controller;
  bool enabled;
  bool? readOnly;
  String? value;
  final onChanged;
  String? Function(String?)? validator;
  final onTap;

  ProfileField({
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
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Row(
          children: [
            Text(
              labelName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(width: 25),
            Container(
              width: MediaQuery.of(context).size.width * .6,
              child: TextFormField(
                decoration: InputDecoration(border: InputBorder.none),
                enabled: enabled,
                controller: controller,
                readOnly: readOnly ?? false,
                initialValue: value,
                style: Theme.of(context).textTheme.bodySmall,
                onChanged: onChanged,
                validator: validator,
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
