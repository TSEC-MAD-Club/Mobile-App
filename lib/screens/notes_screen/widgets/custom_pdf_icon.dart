import 'package:flutter/material.dart';

class CustomPdfIcon extends StatelessWidget {
  final String pdfName;
  final VoidCallback method;
  const CustomPdfIcon({super.key, required this.pdfName, required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.03,
      width: MediaQuery.of(context).size.width * 0.37,
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
            const SizedBox(
              width: 7,
            ),
            InkWell(
              onTap: method,
              child: const Icon(
                Icons.cancel_outlined,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
