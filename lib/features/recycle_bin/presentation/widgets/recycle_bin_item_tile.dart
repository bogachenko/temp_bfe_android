import 'package:flutter/material.dart';

import '../../../../theme/app_sizes.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../domain/recycle_bin_item.dart';
import '../recycle_bin_item_formatter.dart';
import 'recycle_bin_item_visual.dart';

class RecycleBinItemTile extends StatelessWidget {
  const RecycleBinItemTile({
    required this.item,
    required this.moreActionsTooltip,
    required this.onMore,
    super.key,
  });

  final RecycleBinItem item;
  final String moreActionsTooltip;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.recycleBinRowHeight,
      child: Stack(
        children: [
          Row(
            children: [
              const SizedBox(width: AppSpacing.md),
              RecycleBinItemVisual(kind: item.kind),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.recycleItemTitle,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      RecycleBinItemFormatter.metadata(context, item),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.recycleItemMetadata,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: AppSizes.recycleBinActionWidth,
                height: AppSizes.recycleBinActionWidth,
                child: IconButton(
                  tooltip: moreActionsTooltip,
                  onPressed: onMore,
                  padding: EdgeInsets.zero,
                  iconSize: AppSizes.recycleBinActionIcon,
                  icon: const Icon(Icons.more_vert),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
          ),
          const Positioned(
            left: AppSizes.recycleBinDividerStart,
            right: AppSpacing.lg,
            bottom: 0,
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
