import 'package:flutter/material.dart';

class CustomTextWithDivider extends StatefulWidget {
  final String label;
  final String value;
  // final bool showDivider; // New field to enable/disable Divider

  const CustomTextWithDivider({
    Key? key, // Don't forget to include the key parameter
    required this.label,
    required this.value,
    // this.showDivider = true, // Default value is true
  }) : super(key: key);

  @override
  State<CustomTextWithDivider> createState() => _CustomTextWithDividerState();
}

class _CustomTextWithDividerState extends State<CustomTextWithDivider> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 15, top: 5, bottom: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey)),
          Text(
            widget.value,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 15, fontWeight: FontWeight.normal),
          ),
          // if (widget.showDivider) // Conditionally display the Divider
          //   Divider(
          //     thickness: 1,
          //     color: Colors.grey.shade800,
          //   ),
        ],
      ),
    );
  }
}
