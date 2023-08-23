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
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 4, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey)),
          Container(height: 2),
          Text(
            widget.value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          if (widget.showDivider) // Conditionally display the Divider
            Divider(
              thickness: 1,
              color: Theme.of(context).colorScheme.outline,
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
