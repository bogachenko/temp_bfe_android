import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_sizes.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

class RecycleBinItemActionsSheet extends StatelessWidget {
  const RecycleBinItemActionsSheet({
    required this.restoreLabel,
    required this.deleteLabel,
    required this.onRestore,
    required this.onDelete,
    super.key,
  });

  final String restoreLabel;
  final String deleteLabel;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionTile(
            icon: Icons.restore,
            label: restoreLabel,
            onTap: onRestore,
          ),
          _ActionTile(
            icon: Icons.delete_outline,
            label: deleteLabel,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.recycleBinBottomSheetItemHeight,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                icon,
                size: AppSizes.recycleBinActionIcon,
                color: AppColors.neutralForeground1,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bottomSheetAction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
