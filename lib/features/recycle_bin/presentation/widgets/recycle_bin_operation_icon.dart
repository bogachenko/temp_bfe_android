import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_sizes.dart';

enum RecycleBinOperationIconKind { delete, restore, info }

class RecycleBinOperationIcon extends StatelessWidget {
  const RecycleBinOperationIcon({
    required this.kind,
    super.key,
  });

  final RecycleBinOperationIconKind kind;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSizes.recycleBinActionIcon,
      child: CustomPaint(painter: _OperationIconPainter(kind)),
    );
  }
}

class _OperationIconPainter extends CustomPainter {
  const _OperationIconPainter(this.kind);

  final RecycleBinOperationIconKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);

    final paint = Paint()
      ..color = AppColors.neutralForeground3
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.recycleBinOperationIconStroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (kind) {
      case RecycleBinOperationIconKind.delete:
        _paintDelete(canvas, paint);
        break;
      case RecycleBinOperationIconKind.restore:
        _paintRestore(canvas, paint);
        break;
      case RecycleBinOperationIconKind.info:
        _paintInfo(canvas, paint);
        break;
    }

    canvas.restore();
  }

  void _paintDelete(Canvas canvas, Paint paint) {
    final body = Path()
      ..moveTo(6.5, 7)
      ..lineTo(7.6, 20)
      ..quadraticBezierTo(7.7, 21, 8.8, 21)
      ..lineTo(15.2, 21)
      ..quadraticBezierTo(16.3, 21, 16.4, 20)
      ..lineTo(17.5, 7);
    canvas.drawPath(body, paint);
    canvas.drawLine(const Offset(4.5, 6), const Offset(19.5, 6), paint);
    canvas.drawLine(const Offset(9, 3.5), const Offset(15, 3.5), paint);
    canvas.drawLine(const Offset(10, 9.5), const Offset(10.5, 17.5), paint);
    canvas.drawLine(const Offset(14, 9.5), const Offset(13.5, 17.5), paint);
  }

  void _paintRestore(Canvas canvas, Paint paint) {
    final circle = Rect.fromCircle(center: const Offset(12, 12), radius: 8.25);
    canvas.drawArc(circle, -0.85, math.pi * 1.72, false, paint);

    final arrow = Path()
      ..moveTo(4, 4)
      ..lineTo(4, 9)
      ..lineTo(9, 9);
    canvas.drawPath(arrow, paint);
    canvas.drawLine(const Offset(12, 7.5), const Offset(12, 12.5), paint);
    canvas.drawLine(const Offset(12, 12.5), const Offset(15.5, 12.5), paint);
  }

  void _paintInfo(Canvas canvas, Paint paint) {
    canvas.drawCircle(const Offset(12, 12), 8.5, paint);
    canvas.drawLine(const Offset(12, 11), const Offset(12, 17), paint);
    canvas.drawCircle(
      const Offset(12, 7.5),
      AppSizes.recycleBinInfoDotRadius,
      Paint()..color = AppColors.neutralForeground3,
    );
  }

  @override
  bool shouldRepaint(covariant _OperationIconPainter oldDelegate) {
    return oldDelegate.kind != kind;
  }
}
