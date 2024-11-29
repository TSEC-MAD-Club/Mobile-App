import 'package:flutter/material.dart';
import 'package:tsec_app/utils/form_validity.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          // boxShadow: isItDarkMode
          //     ? shadowLightModeTextFields
          //     : shadowDarkModeTextFields,
        ),
        child: TextFormField(
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter an email';
            }
            if (!isValidEmail(value)) {
              return 'Please enter a Valid Email';
            }
            return null;
          },
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff353F5A),
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(18),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            filled: true,
            hintStyle: TextStyle(
              color: Color(0xff6B708C),
            ),
            hintText: hintText,
            fillColor: Color(0xff191B22),
          ),
        ),
      ),
    );
  }
}
