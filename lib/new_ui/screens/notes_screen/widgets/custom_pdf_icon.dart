import 'package:flutter/material.dart';

class CustomPdfIcon extends StatelessWidget {
  final String pdfName;

  const CustomPdfIcon({Key? key, required this.pdfName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.file_copy,
                color: Colors.white,
                size: 15,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  pdfName,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
