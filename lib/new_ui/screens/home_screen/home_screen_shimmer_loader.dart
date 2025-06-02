import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreenShimmerLoader extends StatelessWidget {
  const HomeScreenShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Shimmer(
                color: Colors.grey,
                colorOpacity: 0.5,
                duration: const Duration(seconds: 3),
                child: Container(
                  width: double.infinity,
                  height: 70,
                  color: Colors.white12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Shimmer(
                color: Colors.grey,
                colorOpacity: 0.5,
                duration: const Duration(seconds: 3),
                child: Container(
                  width: 200,
                  height: 20,
                  color: Colors.white12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Shimmer(
                color: Colors.grey,
                colorOpacity: 0.5,
                duration: const Duration(seconds: 3),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.white12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Shimmer(
                color: Colors.grey,
                colorOpacity: 0.5,
                duration: const Duration(seconds: 3),
                child: Container(
                  width: 75,
                  height: 20,
                  color: Colors.white12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Shimmer(
                color: Colors.grey,
                colorOpacity: 0.5,
                duration: const Duration(seconds: 3),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.white12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Shimmer(
                color: Colors.grey,
                colorOpacity: 0.5,
                duration: const Duration(seconds: 3),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.white12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Shimmer(
                color: Colors.grey,
                colorOpacity: 0.5,
                duration: const Duration(seconds: 3),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.white12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
