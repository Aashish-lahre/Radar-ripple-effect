import 'package:flutter/material.dart';

class ConcentricRippleAnimation extends StatefulWidget {
  const ConcentricRippleAnimation({super.key});

  @override
  State<ConcentricRippleAnimation> createState() => _ConcentricRippleAnimationState();
}

class _ConcentricRippleAnimationState extends State<ConcentricRippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
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



/// Understanding Formula = [(animation.value + (i / numberOfCircles)) % 1;]
/// 
/// 
/// 1. [animation.value]:
/// This is your base progress for the entire animation. It continuously moves from 0.0 to 1.0.

/// 2. [(i / numberOfCircles):]

/// Assume you have numberOfCircles = 5.

/// For each circle, i (from 0 up to 4) represents its index.

/// Calculating i / numberOfCircles gives a fraction that is different for each circle:

/// For circle 0: offset is 0 / 5 = 0.0

/// For circle 1: offset is 1 / 5 = 0.2

/// For circle 2: offset is 2 / 5 = 0.4

/// And so on...

/// This value represents where in the cycle that particular circle should start.
/// It creates an even spacing between the starting points of each circle.

/// 3. [Adding Them Together:]

/// animation.value + (i / numberOfCircles)
/// This gives a new value that “shifts” the animation progress for each circle.

/// For example, if animation.value is 0.3:

/// Circle 0: Effective progress = 0.3 + 0.0 = 0.3

/// Circle 1: Effective progress = 0.3 + 0.2 = 0.5

/// Circle 2: Effective progress = 0.3 + 0.4 = 0.7

/// And so on...

/// Each circle now appears at a different stage in its growth cycle.

/// 4. [Modulo Operation % 1:]

/// The % 1 ensures that the result is always between 0.0 and 1.0.

/// For instance, if the sum becomes 1.1, then 1.1 % 1 equals 0.1.

/// This “wraps around” the value, meaning when a circle reaches the end (1.0), it starts again from 0.0.

/// 5. [Result:]
/// Each circle’s "effective progress" is now staggered.

/// When you multiply this effective progress by the maximum radius, each circle will have a different size at any given time.

/// This creates the effect of continuous, overlapping ripples where some circles are small and just starting while others are larger and almost finished.