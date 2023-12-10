import 'package:flutter/material.dart';

class CustomPdfIcon extends StatelessWidget {
  final String pdfName;
  const CustomPdfIcon({super.key, required this.pdfName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.03,
      width: MediaQuery.of(context).size.width * 0.30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            const Icon(
              Icons.file_copy,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              pdfName,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
