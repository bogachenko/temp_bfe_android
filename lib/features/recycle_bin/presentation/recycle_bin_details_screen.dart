import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_typography.dart';
import '../domain/recycle_bin_item.dart';
import 'recycle_bin_item_formatter.dart';
import 'widgets/recycle_bin_item_visual.dart';
import 'widgets/recycle_bin_operation_icon.dart';

class RecycleBinDetailsScreen extends StatelessWidget {
  const RecycleBinDetailsScreen({
    required this.item,
    super.key,
  });

  final RecycleBinItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recycleDetails)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSizes.recycleBinDetailsTopSpacing),
            Center(
              child: SizedBox.square(
                dimension: AppSizes.recycleBinDetailsVisualBox,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: RecycleBinItemVisual(kind: item.kind),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _DetailsAction(
                    iconKind: RecycleBinOperationIconKind.restore,
                    label: l10n.recycleRestore,
                    onTap: () => _restore(context),
                  ),
                ),
                Expanded(
                  child: _DetailsAction(
                    iconKind: RecycleBinOperationIconKind.delete,
                    label: l10n.recycleDelete,
                    onTap: () => _confirmDeleteItem(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(item.name, style: AppTypography.detailsFileName),
            ),
            const SizedBox(height: AppSpacing.xl),
            _PropertyRow(
              label: l10n.recycleDetailsType,
              value: RecycleBinItemFormatter.type(context, item),
            ),
            _PropertyRow(
              label: l10n.recycleDetailsSize,
              value: RecycleBinItemFormatter.size(context, item),
            ),
            _PropertyRow(
              label: l10n.recycleDetailsModified,
              value: RecycleBinItemFormatter.fullModified(context, item),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  void _restore(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).recycleRestored)),
    );
  }

  Future<void> _confirmDeleteItem(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.recycleDeleteItemConfirmationTitle(item.name)),
          content: Text(l10n.recycleDeleteItemConfirmationBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              style: AppTheme.destructiveTextButtonStyle,
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.recycleDelete),
            ),
          ],
        );
      },
    );
  }
}

class _DetailsAction extends StatelessWidget {
  const _DetailsAction({
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
      height: AppSizes.recycleBinDetailsActionHeight,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RecycleBinOperationIcon(kind: iconKind),
            const SizedBox(height: AppSpacing.sm),
            Text(label, style: AppTypography.detailsActionLabel),
          ],
        ),
      ),
    );
  }
}

class _PropertyRow extends StatelessWidget {
  const _PropertyRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.recycleBinDetailsPropertyRowHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Row(
          children: [
            Text(label, style: AppTypography.detailsPropertyLabel),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTypography.detailsPropertyValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
