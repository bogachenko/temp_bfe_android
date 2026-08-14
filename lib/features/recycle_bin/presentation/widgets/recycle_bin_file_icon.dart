import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_gradients.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_sizes.dart';
import '../../../../theme/app_typography.dart';
import '../../domain/recycle_bin_item.dart';

class RecycleBinFileIcon extends StatelessWidget {
  const RecycleBinFileIcon({
    required this.kind,
    super.key,
  });

  final RecycleBinItemKind kind;

  @override
  Widget build(BuildContext context) {
    if (kind == RecycleBinItemKind.folder) {
      return const SizedBox.square(
        dimension: AppSizes.recycleBinVisualBox,
        child: Center(
          child: SizedBox.square(
            dimension: AppSizes.recycleBinFolderGlyph,
            child: CustomPaint(
              painter: _OneDriveFolderPainter(),
            ),
          ),
        ),
      );
    }

    final (badgeLabel, badgeColor) = switch (kind) {
      RecycleBinItemKind.pdf => ('PDF', AppColors.filePdf),
      RecycleBinItemKind.word => ('W', AppColors.fileWord),
      RecycleBinItemKind.excel => ('X', AppColors.fileExcel),
      RecycleBinItemKind.genericFile => (null, AppColors.fileGeneric),
      RecycleBinItemKind.folder => (null, AppColors.fileGeneric),
    };

    return SizedBox.square(
      dimension: AppSizes.recycleBinVisualBox,
      child: CustomPaint(
        painter: _FileTypePainter(
          badgeLabel: badgeLabel,
          badgeColor: badgeColor,
        ),
      ),
    );
  }
}

class _OneDriveFolderPainter extends CustomPainter {
  const _OneDriveFolderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 36;
    final scaleY = size.height / 36;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    final back = Path()
      ..moveTo(4, 6)
      ..lineTo(13.0883, 6)
      ..cubicTo(13.9504, 6, 14.7708, 6.3709, 15.3404, 7.0181)
      ..lineTo(17.1111, 9.0302)
      ..lineTo(32, 9.0302)
      ..cubicTo(33.1046, 9.0302, 34, 9.9256, 34, 11.0302)
      ..lineTo(34, 28)
      ..cubicTo(34, 29.1046, 33.1046, 30, 32, 30)
      ..lineTo(4, 30)
      ..cubicTo(2.8954, 30, 2, 29.1046, 2, 28)
      ..lineTo(2, 8)
      ..cubicTo(2, 6.8954, 2.8954, 6, 4, 6)
      ..close();

    canvas.drawPath(
      back,
      Paint()..color = AppColors.recycleFolderBack,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(4, 11, 32, 28),
        const Radius.circular(0.5),
      ),
      Paint()..color = AppColors.neutralForegroundStaticLight,
    );

    final front = Path()
      ..moveTo(2, 12.0062)
      ..lineTo(13.0954, 12.0062)
      ..cubicTo(13.9534, 12.0062, 14.7703, 11.6389, 15.3397, 10.997)
      ..lineTo(17.1111, 9)
      ..lineTo(32, 9)
      ..cubicTo(33.1046, 9, 34, 9.8954, 34, 11)
      ..lineTo(34, 28)
      ..cubicTo(34, 29.1046, 33.1046, 30, 32, 30)
      ..lineTo(4, 30)
      ..cubicTo(2.8954, 30, 2, 29.1046, 2, 28)
      ..lineTo(2, 12.0062)
      ..close();

    canvas.drawPath(
      front,
      Paint()..color = AppColors.recycleFolderFront,
    );

    canvas.drawPath(
      front,
      Paint()
        ..shader = AppGradients.recycleFolderHighlight.createShader(
          const Rect.fromLTRB(0, 9, 36, 30),
        ),
    );

    final bottomEdge = Path()
      ..moveTo(33.9147, 28.5797)
      ..cubicTo(33.6662, 29.4016, 32.903, 30, 32, 30)
      ..lineTo(4, 30)
      ..cubicTo(3.097, 30, 2.3338, 29.4016, 2.0853, 28.5797)
      ..cubicTo(2.3952, 28.8498, 2.7934, 29, 3.2071, 29)
      ..lineTo(32.7934, 29)
      ..cubicTo(33.2069, 29, 33.605, 28.8498, 33.9147, 28.5797)
      ..close();

    canvas.drawPath(
      bottomEdge,
      Paint()..color = AppColors.recycleFolderBottom,
    );

    final seam = Path()
      ..moveTo(2, 12)
      ..lineTo(13.1339, 12)
      ..cubicTo(14.0018, 12, 14.8271, 11.6242, 15.3969, 10.9696)
      ..lineTo(17.1111, 9)
      ..lineTo(18.5, 9)
      ..lineTo(16.0458, 11.8048)
      ..cubicTo(15.3812, 12.5643, 14.4211, 13, 13.4118, 13)
      ..lineTo(2, 13)
      ..close();

    canvas.drawPath(
      seam,
      Paint()
        ..color = AppColors.neutralForegroundStaticLight.withValues(alpha: 0.4),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OneDriveFolderPainter oldDelegate) => false;
}

class _FileTypePainter extends CustomPainter {
  const _FileTypePainter({
    required this.badgeLabel,
    required this.badgeColor,
  });

  final String? badgeLabel;
  final Color badgeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final page = Path()
      ..moveTo(8, 2)
      ..lineTo(23, 2)
      ..lineTo(32, 11)
      ..lineTo(32, 35)
      ..quadraticBezierTo(32, 37, 30, 37)
      ..lineTo(8, 37)
      ..quadraticBezierTo(6, 37, 6, 35)
      ..lineTo(6, 4)
      ..quadraticBezierTo(6, 2, 8, 2)
      ..close();

    canvas.drawPath(
      page,
      Paint()..color = AppColors.fileSurface,
    );
    canvas.drawPath(
      page,
      Paint()
        ..color = AppColors.fileStroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final fold = Path()
      ..moveTo(23, 2)
      ..lineTo(23, 10)
      ..quadraticBezierTo(23, 11, 24, 11)
      ..lineTo(32, 11)
      ..close();

    canvas.drawPath(
      fold,
      Paint()..color = AppColors.fileFold,
    );
    canvas.drawPath(
      fold,
      Paint()
        ..color = AppColors.fileStroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    if (badgeLabel == null) {
      final linePaint = Paint()
        ..color = AppColors.fileGeneric
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(const Offset(11, 20), const Offset(27, 20), linePaint);
      canvas.drawLine(const Offset(11, 24), const Offset(24, 24), linePaint);
      canvas.drawLine(const Offset(11, 28), const Offset(21, 28), linePaint);
      return;
    }

    final badgeRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(2, 21, 23, 13),
      const Radius.circular(AppRadius.fileTypeBadge),
    );
    canvas.drawRRect(
      badgeRect,
      Paint()..color = badgeColor,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: badgeLabel,
        style: AppTypography.fileTypeBadge,
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        13.5 - textPainter.width / 2,
        27.5 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _FileTypePainter oldDelegate) {
    return oldDelegate.badgeLabel != badgeLabel ||
        oldDelegate.badgeColor != badgeColor;
  }
}
