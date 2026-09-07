import 'package:flutter/material.dart';

class RedDiagonalStripesBackground extends StatelessWidget {
  final Color primaryColor;
  final Color stripeColor;
  final double stripeWidth;
  final double stripeSpacing;
  final Widget? child;

  const RedDiagonalStripesBackground({
    super.key,
    this.primaryColor = const Color(0xFFE31937),
    this.stripeColor = const Color(0xFFC7132B),
    this.stripeWidth = 22.0,
    this.stripeSpacing = 22.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RedDiagonalStripesPainter(
        primaryColor: primaryColor,
        stripeColor: stripeColor,
        stripeWidth: stripeWidth,
        stripeSpacing: stripeSpacing,
      ),
      child: child,
    );
  }
}

class RedDiagonalStripesPainter extends CustomPainter {
  final Color primaryColor;
  final Color stripeColor;
  final double stripeWidth;
  final double stripeSpacing;

  const RedDiagonalStripesPainter({
    this.primaryColor = const Color(0xFFE31937),
    this.stripeColor = const Color(0xFFC7132B),
    this.stripeWidth = 22.0,
    this.stripeSpacing = 22.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = primaryColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final stripePaint = Paint()
      ..color = stripeColor
      ..strokeWidth = stripeWidth
      ..style = PaintingStyle.stroke;

    final totalStep = stripeWidth + stripeSpacing;
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    final start = -size.height * 2;
    final end = size.width + size.height * 2;

    for (double x = start; x < end; x += totalStep) {
      canvas.drawLine(
        Offset(x, -20),
        Offset(x + size.height + 40, size.height + 20),
        stripePaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
