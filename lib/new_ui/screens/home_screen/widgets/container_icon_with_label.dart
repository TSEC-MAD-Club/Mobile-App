// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ContainerIconWithName extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const ContainerIconWithName({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 125,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: _theme.colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50.0,
                  color: _theme.scaffoldBackgroundColor,
                ),
                SizedBox(height: 10.0),
                Text(
                  text,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 20, color: _theme.colorScheme.onTertiary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
