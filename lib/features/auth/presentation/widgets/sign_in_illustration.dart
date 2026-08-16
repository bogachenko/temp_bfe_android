import 'package:flutter/material.dart';

import '../../../../theme/app_gradients.dart';

class SignInIllustration extends StatelessWidget {
  const SignInIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _SignInIllustrationPainter(),
      child: SizedBox.expand(),
    );
  }
}

class _SignInIllustrationPainter extends CustomPainter {
  const _SignInIllustrationPainter();

  static const double _sourceWidth = 512;
  static const double _sourceHeight = 513;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _sourceWidth;
    final scaleY = size.height / _sourceHeight;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final dx = (size.width - (_sourceWidth * scale)) / 2;
    final dy = (size.height - (_sourceHeight * scale)) / 2;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);

    _drawBackgroundPanels(canvas);
    _drawColoredPanels(canvas);
    _drawOrbs(canvas);
    _drawDots(canvas);
    _drawHighlights(canvas);

    canvas.restore();
  }

  void _drawBackgroundPanels(Canvas canvas) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFFE7E7E8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(117.5, 120.5, 316.5, 212.14),
        const Radius.circular(27),
      ),
      paint,
    );

    paint.color = const Color(0xBDE6E0F1);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(67.21, 234, 208.79, 160.5),
        const Radius.circular(15),
      ),
      paint,
    );

    paint.color = const Color(0xC7E4DFF0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(363, 229, 107.59, 165.5),
        const Radius.circular(15),
      ),
      paint,
    );
  }

  void _drawColoredPanels(Canvas canvas) {
    final paint = Paint()..style = PaintingStyle.fill;

    final purpleRect = const Rect.fromLTWH(117.5, 234, 158.5, 100.64);
    paint.shader = AppGradients.signInPurpleOrange.createShader(purpleRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(purpleRect, const Radius.circular(17)),
      paint,
    );

    final greenRect = const Rect.fromLTWH(363, 229, 71, 103.64);
    paint.shader = AppGradients.signInGreenBlue.createShader(greenRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(greenRect, const Radius.circular(15)),
      paint,
    );

    final orangePath = Path()
      ..moveTo(276, 332.64)
      ..lineTo(326.33, 332.64)
      ..lineTo(347.66, 372.62)
      ..cubicTo(353.27, 383.15, 345.64, 394.5, 333.71, 394.5)
      ..lineTo(276, 394.5)
      ..close();
    final orangeBounds = orangePath.getBounds();
    paint.shader = AppGradients.signInOrange.createShader(orangeBounds);
    canvas.drawPath(orangePath, paint);

    final beigePath = Path()
      ..moveTo(47.84, 368.15)
      ..lineTo(276, 368.15)
      ..lineTo(276, 394.5)
      ..lineTo(64, 394.5)
      ..cubicTo(52.26, 394.5, 42.75, 384.98, 42.75, 373.24)
      ..cubicTo(42.75, 370.43, 45.03, 368.15, 47.84, 368.15)
      ..close();
    paint.shader = AppGradients.signInBeige.createShader(beigePath.getBounds());
    canvas.drawPath(beigePath, paint);

    paint.shader = null;
  }

  void _drawOrbs(Canvas canvas) {
    final shadowPaint = Paint()
      ..color = const Color(0x248D8394)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(275.46, 184), width: 56, height: 36),
      shadowPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(171.15, 281), width: 36, height: 22),
      shadowPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(416.9, 270), width: 36, height: 22),
      shadowPaint,
    );

    final paint = Paint()..style = PaintingStyle.fill;

    void drawBall(Offset center, double radius) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      paint.shader = AppGradients.signInBall.createShader(rect);
      canvas.drawCircle(center, radius, paint);
    }

    drawBall(const Offset(275.46, 162.65), 21.08);
    drawBall(const Offset(171.15, 267.11), 13.11);
    drawBall(const Offset(416.9, 256.5), 13.11);

    paint.shader = null;
  }

  void _drawDots(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFF2498DD)
      ..style = PaintingStyle.fill;

    const dots = <(Offset, double)>[
      (Offset(330.13, 380.67), 1.98),
      (Offset(314.98, 365.52), 2.63),
      (Offset(283, 338.55), 2),
      (Offset(247.41, 255.22), 1.22),
      (Offset(202.56, 262.44), 1.56),
      (Offset(267.82, 262.44), 1.56),
      (Offset(207.75, 264.44), 2),
      (Offset(177, 295.25), 2.25),
      (Offset(160.75, 314.38), 1.63),
      (Offset(123, 303.75), 1.63),
    ];

    for (final (center, radius) in dots) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  void _drawHighlights(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFF2F1F3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(117.5, 233, 160.5, 101.64),
        const Radius.circular(17),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(362, 228, 73, 105.64),
        const Radius.circular(16),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SignInIllustrationPainter oldDelegate) => false;
}
