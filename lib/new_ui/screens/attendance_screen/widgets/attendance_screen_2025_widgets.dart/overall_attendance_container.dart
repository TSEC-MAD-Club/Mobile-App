import 'package:flutter/material.dart';

class OverallAttendance extends StatefulWidget {
  final double width;
  const OverallAttendance({super.key, required this.width});
  @override
  State<OverallAttendance> createState() => _OverallAttendanceState();
}

class _OverallAttendanceState extends State<OverallAttendance> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: widget.width,
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
                width: widget.width * 0.30,
                height: widget.width * 0.30,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(widget.width * 0.5, widget.width * 0.5),
                      painter: CircleProgressPainter(0.75), // 50%
                    ),

                    Container(
                      width: widget.width * 0.36,
                      height: widget.width * 0.36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2D2D2D),
                        shape: BoxShape.circle,
                      ),
                    ),

                    // Percentage text
                    const Text(
                      "50%",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(spacing: 10, children: [
                Text(
                  'LECTURES ATTENDED',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '1' + '/' + '2',

                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Keep it up!',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 111, 111, 115),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ])
            ],
          ),
        ),
      ),
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
