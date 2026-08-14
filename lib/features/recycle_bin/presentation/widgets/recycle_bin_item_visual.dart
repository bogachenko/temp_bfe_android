import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_sizes.dart';
import '../../domain/recycle_bin_item.dart';
import 'recycle_bin_file_icon.dart';

class RecycleBinItemVisual extends StatelessWidget {
  const RecycleBinItemVisual({
    required this.kind,
    super.key,
  });

  final RecycleBinItemKind kind;

  @override
  Widget build(BuildContext context) {
    if (kind != RecycleBinItemKind.genericFile) {
      return RecycleBinFileIcon(kind: kind);
    }

    return const SizedBox.square(
      dimension: AppSizes.recycleBinVisualBox,
      child: CustomPaint(painter: _GenericFilePainter()),
    );
  }
}

class _GenericFilePainter extends CustomPainter {
  const _GenericFilePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        AppSizes.recycleGenericFileHorizontalInset,
        AppSizes.recycleGenericFileVerticalInset,
        size.width - AppSizes.recycleGenericFileHorizontalInset,
        size.height - AppSizes.recycleGenericFileVerticalInset,
      ),
      const Radius.circular(AppRadius.recycleGenericFile),
    );

    canvas.drawRRect(rect, Paint()..color = AppColors.fileSurface);
    canvas.drawRRect(
      rect,
      Paint()
        ..color = AppColors.fileStroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSizes.recycleGenericFileStroke,
    );
  }

  @override
  bool shouldRepaint(covariant _GenericFilePainter oldDelegate) => false;
}
