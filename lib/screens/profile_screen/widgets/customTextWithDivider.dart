import 'package:flutter/material.dart';

class CustomTextWithDivider extends StatefulWidget {
  final String label;
  final String value;
  final bool showDivider; // New field to enable/disable Divider

  const CustomTextWithDivider({
    Key? key, // Don't forget to include the key parameter
    required this.label,
    required this.value,
    this.showDivider = true, // Default value is true
  }) : super(key: key);

  @override
  State<CustomTextWithDivider> createState() => _CustomTextWithDividerState();
}

class _CustomTextWithDividerState extends State<CustomTextWithDivider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
        ),
        Text(widget.value),
        if (widget.showDivider) // Conditionally display the Divider
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
      ],
    );
  }
}
