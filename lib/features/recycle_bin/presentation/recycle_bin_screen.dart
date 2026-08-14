import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../domain/recycle_bin_item.dart';
import 'widgets/recycle_bin_item_actions_sheet.dart';
import 'widgets/recycle_bin_item_tile.dart';

class RecycleBinScreen extends StatelessWidget {
  const RecycleBinScreen({super.key});

  static const _sampleItems = [
    RecycleBinItem(
      name: 'Projects',
      metadata: '2.9 GB · 2026-08-14',
      kind: RecycleBinItemKind.folder,
    ),
    RecycleBinItem(
      name: 'Archive',
      metadata: '604 MB · 2026-08-13',
      kind: RecycleBinItemKind.folder,
    ),
    RecycleBinItem(
      name: 'Quarterly report.pdf',
      metadata: '1.2 MB · 2026-07-14',
      kind: RecycleBinItemKind.pdf,
    ),
    RecycleBinItem(
      name: 'Budget 2026.xlsx',
      metadata: '84 KB · 2026-07-12',
      kind: RecycleBinItemKind.excel,
    ),
    RecycleBinItem(
      name: 'Contract.docx',
      metadata: '243 KB · 2026-07-08',
      kind: RecycleBinItemKind.word,
    ),
    RecycleBinItem(
      name: 'notes.txt',
      metadata: '8 KB · 2026-07-03',
      kind: RecycleBinItemKind.genericFile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(l10n.recycleBinTitle),
        actions: [
          TextButton(
            style: AppTheme.toolbarActionButtonStyle,
            onPressed: () => _confirmEmptyRecycleBin(context),
            child: Text(l10n.recycleDeleteAll.toUpperCase()),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _sampleItems.length,
        itemBuilder: (context, index) {
          final item = _sampleItems[index];
          return RecycleBinItemTile(
            item: item,
            moreActionsTooltip: l10n.recycleMoreActions,
            onMore: () => _showItemActions(context, item),
          );
        },
      ),
    );
  }

  Future<void> _showItemActions(
    BuildContext context,
    RecycleBinItem item,
  ) async {
    final l10n = AppLocalizations.of(context);

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (sheetContext) {
        return RecycleBinItemActionsSheet(
          restoreLabel: l10n.recycleRestore,
          deleteLabel: l10n.recycleDelete,
          onRestore: () {
            Navigator.of(sheetContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.recycleRestored)),
            );
          },
          onDelete: () {
            Navigator.of(sheetContext).pop();
            _confirmDeleteItem(context, item);
          },
        );
      },
    );
  }

  Future<void> _confirmEmptyRecycleBin(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.recycleEmptyConfirmationTitle),
          content: Text(l10n.recycleEmptyConfirmationBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              style: AppTheme.destructiveTextButtonStyle,
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.recycleDeleteAll),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteItem(
    BuildContext context,
    RecycleBinItem item,
  ) async {
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
