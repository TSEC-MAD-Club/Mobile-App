import 'package:flutter/material.dart';

class DropDownMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const DropDownMenuItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title, style: Theme.of(context).textTheme.bodyText2),
      ),
    );
  }
}
