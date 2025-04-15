import 'package:flutter/material.dart';

class BoxAnimation extends StatefulWidget {
  const BoxAnimation({super.key});

  @override
  State<BoxAnimation> createState() => _BoxAnimationState();
}

class _BoxAnimationState extends State<BoxAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Use repeat() so that the animation continuously plays.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust for ripple speed.
    )..forward()..repeat(); // Repeat forever.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // The outer container is circular with a border.
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Stack(
            children: [
              // Radar Ripple Effect via CustomPainter.
              Positioned.fill(
                child: CustomPaint(
                  painter: RadarPainter(animation: _controller),
                ),
              ),
              // The central circle (e.g., a sensor or marker).
              Positioned.fill(
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class RadarPainter extends CustomPainter {
  RadarPainter({required this.animation}) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    // Center of the container.
    final center = Offset(size.width / 2, size.height / 2);
    // Maximum radius is half the width (or height) of the container.
    final maxRadius = size.width / 2;
    // Number of ripple circles to draw.
    const int numberOfCircles = 5;

    // Define the paint configuration.
    final Paint circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw each circle with a phase offset.
    for (int i = 0; i < numberOfCircles; i++) {
      // Compute an offset progress for the ripple; ensures staggered phases:
      final double offsetProgress =
          (animation.value + (i / numberOfCircles)) % 1;

      // Compute the radius for the ripple.
      final circleRadius = offsetProgress * maxRadius;

      // Create a fade effect: the ripple fades out as it expands.
      final Color rippleColor =
          Colors.blue.withOpacity(1.0 - offsetProgress);
      circlePaint.color = rippleColor;

      // Draw the circle.
      canvas.drawCircle(center, circleRadius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) => true;
}
