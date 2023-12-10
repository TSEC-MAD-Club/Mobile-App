import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Widget _buildCustomButton(String buttonText, void Function() onPressed, List<bool> isSelected, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(buttonText),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              // Change color based on the selection
              if (isSelected[index]) {
                return Colors.blue; // Selected color
              }
              return Colors.grey; // Default color
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              // Change text color based on the selection
              if (isSelected[index]) {
                return Colors.white; // Selected text color
              }
              return Colors.black; // Default text color
            },
          ),
        ),
      ),
    );
  }
}

