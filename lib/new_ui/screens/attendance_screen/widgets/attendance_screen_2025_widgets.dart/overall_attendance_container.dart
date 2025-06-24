import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../attendance_totals_provider.dart';

class OverallAttendance extends ConsumerWidget {
  final double width;
  const OverallAttendance({super.key, required this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceTotalsProvider);

    return attendanceAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text("Error loading attendance", style: TextStyle(color: Colors.red))),
      data: (data) {
        int attend = 0;
        int tot = 0;
        data.attended.forEach((key, value){
          attend += value;
        });
        data.total.forEach((key, value){
          tot += value;
        });
        double percentage = tot > 0 ? attend / tot : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D2D),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.30,
                    height: width * 0.30,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size(width * 0.5, width * 0.5),
                          painter: CircleProgressPainter(percentage),
                        ),
                        Container(
                          width: width * 0.36,
                          height: width * 0.36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2D2D2D),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          "${(percentage * 100).round()}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LECTURES ATTENDED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${attend}/${tot}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        percentage >= 0.75 ? "Keep it up!" : "Needs improvement",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 111, 111, 115),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class CircleProgressPainter extends CustomPainter {
  final double percentage;

  CircleProgressPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final Rect circleRect = Rect.fromCircle(center: center, radius: radius);

    Paint backgroundPaint = Paint()
      ..color = Color.fromARGB(175, 89, 91, 95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      circleRect,
      -3.141592 / 2,
      2 * 3.141592,
      false,
      backgroundPaint,
    );

    // Foreground progress arc
    Paint foregroundPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    double sweepAngle = 2 * 3.141592 * percentage;

    canvas.drawArc(
      circleRect,
      -3.141592 / 2,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
