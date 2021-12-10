import 'package:flutter/material.dart';
import 'package:tsec_app/utils/themes.dart';

class FacultyDetailsSection extends StatefulWidget {
  const FacultyDetailsSection({ Key? key }) : super(key: key);

  @override
  _FacultyDetailsSectionState createState() => _FacultyDetailsSectionState();
}

class _FacultyDetailsSectionState extends State<FacultyDetailsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Faculty Details"),
    );
  }
}