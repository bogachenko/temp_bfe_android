import 'package:flutter/material.dart';

import '../../../../theme/app_sizes.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../domain/recycle_bin_item.dart';
import '../recycle_bin_item_formatter.dart';
import 'recycle_bin_item_visual.dart';
import 'recycle_bin_operation_icon.dart';

class RecycleBinItemActionsSheet extends StatelessWidget {
  const RecycleBinItemActionsSheet({
    required this.item,
    required this.restoreLabel,
    required this.deleteLabel,
    required this.detailsLabel,
    required this.onRestore,
    required this.onDelete,
    required this.onDetails,
    super.key,
  });

  final RecycleBinItem item;
  final String restoreLabel;
  final String deleteLabel;
  final String detailsLabel;
  final VoidCallback onRestore;
  final VoidCallback onDelete;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            SizedBox.square(
              dimension: AppSizes.recycleBinBottomSheetPreviewVisual,
              child: FittedBox(
                fit: BoxFit.contain,
                child: RecycleBinItemVisual(kind: item.kind),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(item.name, style: AppTypography.bottomSheetPreviewName),
            const SizedBox(height: AppSpacing.xs),
            Text(
              RecycleBinItemFormatter.metadata(context, item),
              style: AppTypography.bottomSheetPreviewMetadata,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            _ActionTile(
              iconKind: RecycleBinOperationIconKind.delete,
              label: deleteLabel,
              onTap: onDelete,
            ),
            _ActionTile(
              iconKind: RecycleBinOperationIconKind.restore,
              label: restoreLabel,
              onTap: onRestore,
            ),
            _ActionTile(
              iconKind: RecycleBinOperationIconKind.info,
              label: detailsLabel,
              onTap: onDetails,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.iconKind,
    required this.label,
    required this.onTap,
  });

  final RecycleBinOperationIconKind iconKind;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.recycleBinBottomSheetItemHeight,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            children: [
              RecycleBinOperationIcon(kind: iconKind),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Text(label, style: AppTypography.bottomSheetAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
