import 'package:flutter/material.dart';

class CustomPdfIcon extends StatelessWidget {
  final String pdfName;
  const CustomPdfIcon({super.key, required this.pdfName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4,0,4,0),
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.03,
        // height: 50,
        width: MediaQuery.of(context).size.width * 0.3,
        // width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.file_copy,
              color: Colors.blue,
              size: 15,
            ),
            const SizedBox(
              width: 4,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                pdfName,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            // InkWell(
            //   onTap: method,
            //   child: const Icon(
            //     Icons.cancel_outlined,
            //     color: Colors.grey,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
