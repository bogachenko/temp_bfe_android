import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../domain/recycle_bin_item.dart';
import 'recycle_bin_details_screen.dart';
import 'widgets/recycle_bin_item_actions_sheet.dart';
import 'widgets/recycle_bin_item_tile.dart';

class RecycleBinScreen extends StatelessWidget {
  const RecycleBinScreen({super.key});

  static final _sampleItems = [
    RecycleBinItem(
      name: '1Cv8tmp',
      sizeBytes: 553 * 1024,
      modifiedAt: DateTime(2026, 7, 14, 23, 38),
      kind: RecycleBinItemKind.genericFile,
      fileType: '.1CD',
    ),
    RecycleBinItem(
      name: '1C_Бухгалтерия учебная',
      sizeBytes: 537709773,
      modifiedAt: DateTime(2026, 7, 14, 18, 12),
      kind: RecycleBinItemKind.folder,
    ),
    RecycleBinItem(
      name: 'Quarterly report.pdf',
      sizeBytes: 1258291,
      modifiedAt: DateTime(2026, 7, 14, 14, 20),
      kind: RecycleBinItemKind.pdf,
      fileType: '.PDF',
    ),
    RecycleBinItem(
      name: 'Budget 2026.xlsx',
      sizeBytes: 84 * 1024,
      modifiedAt: DateTime(2026, 7, 12, 10, 5),
      kind: RecycleBinItemKind.excel,
      fileType: '.XLSX',
    ),
    RecycleBinItem(
      name: 'Contract.docx',
      sizeBytes: 243 * 1024,
      modifiedAt: DateTime(2026, 7, 8, 16, 40),
      kind: RecycleBinItemKind.word,
      fileType: '.DOCX',
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
      isScrollControlled: true,
      builder: (sheetContext) {
        return RecycleBinItemActionsSheet(
          item: item,
          restoreLabel: l10n.recycleRestore,
          deleteLabel: l10n.recycleDelete,
          detailsLabel: l10n.recycleDetails,
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
          onDetails: () {
            Navigator.of(sheetContext).pop();
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RecycleBinDetailsScreen(item: item),
              ),
            );
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
