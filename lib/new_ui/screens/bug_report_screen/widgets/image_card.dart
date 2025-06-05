import 'dart:io';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final File image;
  final Function remImg;
  const ImageCard({super.key, required this.image, required this.remImg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              image,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
              top: -7,
              right: -12,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.black38, // Background color
                ),
                child: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  remImg(image);
                },
              )),
        ],
      ),
    );
  }
}
