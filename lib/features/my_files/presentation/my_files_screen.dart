import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_motion.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_shadows.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../data/mock_drive_items.dart';
import '../domain/drive_item.dart';
import 'widgets/drive_item_icon.dart';

enum MyFilesViewMode { list, icons }

enum MyFilesSort {
  nameAscending,
  nameDescending,
  modifiedNewest,
  modifiedOldest,
  sizeSmallest,
  sizeLargest,
}

class MyFilesScreen extends StatefulWidget {
  const MyFilesScreen({
    super.key,
    this.items = mockDriveItems,
    this.accountDisplayName = 'Ivan',
  });

  final List<DriveItem> items;
  final String accountDisplayName;

  @override
  State<MyFilesScreen> createState() => _MyFilesScreenState();
}

class _MyFilesScreenState extends State<MyFilesScreen> {
  MyFilesViewMode _viewMode = MyFilesViewMode.list;
  MyFilesSort _sort = MyFilesSort.nameAscending;
  bool _fabExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = widget.items.toList(growable: false)..sort(_compareItems);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.neutralBackground1,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: AppColors.neutralBackground1,
      ),
      child: Scaffold(
        backgroundColor: AppColors.neutralBackground1,
        body: SafeArea(
          child: Stack(
            key: const Key('myFilesScreen'),
            children: [
              Column(
                children: [
                  _TopBar(accountDisplayName: widget.accountDisplayName),
                  const _PivotBar(),
                  _BrowserHeader(
                    sort: _sort,
                    viewMode: _viewMode,
                    onSortChanged: (value) => setState(() => _sort = value),
                    onViewModeChanged: (value) =>
                        setState(() => _viewMode = value),
                  ),
                  Expanded(
                    child: _viewMode == MyFilesViewMode.list
                        ? _ListView(
                            items: items,
                            displayName: (item) => _displayName(l10n, item),
                            metadata: (item) => _metadata(l10n, item),
                            onMore: _showActions,
                          )
                        : _IconGrid(
                            items: items,
                            displayName: (item) => _displayName(l10n, item),
                            metadata: (item) => _metadata(l10n, item),
                            onMore: _showActions,
                          ),
                  ),
                ],
              ),
              const _SearchPill(),
              if (_fabExpanded) const _CreateMenu(),
              _CreateFab(
                expanded: _fabExpanded,
                onPressed: () => setState(() => _fabExpanded = !_fabExpanded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _compareItems(DriveItem a, DriveItem b) {
    final aGroup = a.isFolder || a.isPersonalVault ? 0 : 1;
    final bGroup = b.isFolder || b.isPersonalVault ? 0 : 1;
    if (aGroup != bGroup) return aGroup.compareTo(bGroup);

    switch (_sort) {
      case MyFilesSort.nameAscending:
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case MyFilesSort.nameDescending:
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      case MyFilesSort.modifiedNewest:
        return b.modifiedSortValue.compareTo(a.modifiedSortValue);
      case MyFilesSort.modifiedOldest:
        return a.modifiedSortValue.compareTo(b.modifiedSortValue);
      case MyFilesSort.sizeSmallest:
        if (a.sizeBytes == null || b.sizeBytes == null) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        }
        return a.sizeBytes!.compareTo(b.sizeBytes!);
      case MyFilesSort.sizeLargest:
        if (a.sizeBytes == null || b.sizeBytes == null) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        }
        return b.sizeBytes!.compareTo(a.sizeBytes!);
    }
  }

  String _displayName(AppLocalizations l10n, DriveItem item) {
    return item.isPersonalVault ? l10n.personalVault : item.name;
  }

  String _metadata(AppLocalizations l10n, DriveItem item) {
    if (item.isPersonalVault) return l10n.tapToSetUp;
    final modified = switch (item.modified) {
      DriveItemModifiedTime.oneHourAgo => l10n.relativeOneHourAgo,
      DriveItemModifiedTime.twoHoursAgo => l10n.relativeTwoHoursAgo,
      DriveItemModifiedTime.yesterday => l10n.relativeYesterday,
      DriveItemModifiedTime.threeDaysAgo => l10n.relativeThreeDaysAgo,
      DriveItemModifiedTime.oneWeekAgo => l10n.relativeOneWeekAgo,
    };
    if (item.isFolder) {
      return l10n.folderMetadata(item.itemCount ?? 0, modified);
    }
    return l10n.fileMetadata(_formatBytes(l10n, item.sizeBytes ?? 0), modified);
  }

  String _formatBytes(AppLocalizations l10n, int bytes) {
    final number = intl.NumberFormat('0.#', l10n.localeName);
    if (bytes >= 1000000000) return '${number.format(bytes / 1000000000)} GB';
    if (bytes >= 1000000) return '${number.format(bytes / 1000000)} MB';
    if (bytes >= 1000) return '${number.format(bytes / 1000)} KB';
    return '$bytes B';
  }

  Future<void> _showActions(DriveItem item) async {
    if (item.isPersonalVault || !item.hasActions) return;
    final l10n = AppLocalizations.of(context);

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralBackground1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.myFilesBottomSheet),
        ),
      ),
      builder: (context) => _ItemActionsSheet(
        item: item,
        title: _displayName(l10n, item),
        metadata: _metadata(l10n, item),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.accountDisplayName});

  final String accountDisplayName;

  String get initials {
    final parts = accountDisplayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return 'A';
    String first(String value) =>
        String.fromCharCode(value.runes.first).toUpperCase();
    if (parts.length == 1) return first(parts.first);
    return '${first(parts.first)}${first(parts.last)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: AppSizes.myFilesTopBarHeight,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: AppSpacing.md),
            child: Semantics(
              button: true,
              child: CircleAvatar(
                radius: AppSizes.myFilesAvatarSize / 2,
                backgroundColor: AppColors.brandAccent,
                foregroundColor: AppColors.onBrand,
                child: Text(
                  initials,
                  style: AppTypography.myFilesMode.copyWith(
                    color: AppColors.onBrand,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                height: AppSizes.myFilesModeSwitcherHeight,
                decoration: BoxDecoration(
                  color: AppColors.neutralBackground2,
                  borderRadius: BorderRadius.circular(
                    AppRadius.myFilesModeSwitcher,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ModeChip(label: l10n.photos, selected: false),
                    _ModeChip(label: l10n.files, selected: true),
                  ],
                ),
              ),
            ),
          ),
          SizedBox.square(
            dimension: AppSizes.myFilesPremiumButtonSize,
            child: IconButton(
              tooltip: l10n.premium,
              onPressed: () {},
              icon: const Icon(
                Icons.diamond_outlined,
                color: AppColors.brandAccent,
                size: AppSizes.myFilesPopupIconSize,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.myFilesModeSwitcherHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: selected ? AppColors.neutralBackground1 : AppColors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.myFilesModeSwitcher),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppTypography.myFilesMode.copyWith(
          color: selected
              ? AppColors.neutralForeground1
              : AppColors.neutralForeground2,
        ),
      ),
    );
  }
}

class _PivotBar extends StatelessWidget {
  const _PivotBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: AppSizes.myFilesPivotBarHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            _Pivot(label: l10n.home, selected: false),
            const SizedBox(width: AppSpacing.xxl),
            _Pivot(label: l10n.myFiles, selected: true),
            const SizedBox(width: AppSpacing.xxl),
            _Pivot(label: l10n.shared, selected: false),
            const SizedBox(width: AppSpacing.xxl),
            _Pivot(label: l10n.personalVault, selected: false),
          ],
        ),
      ),
    );
  }
}

class _Pivot extends StatelessWidget {
  const _Pivot({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.myFilesPivotBarHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            label,
            style: selected
                ? AppTypography.myFilesPivotSelected
                : AppTypography.myFilesPivot,
          ),
          if (selected)
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              child: Container(
                height: AppSizes.myFilesPivotIndicatorHeight,
                decoration: BoxDecoration(
                  color: AppColors.brandAccent,
                  borderRadius: BorderRadius.circular(
                    AppRadius.myFilesPivotIndicator,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BrowserHeader extends StatelessWidget {
  const _BrowserHeader({
    required this.sort,
    required this.viewMode,
    required this.onSortChanged,
    required this.onViewModeChanged,
  });

  final MyFilesSort sort;
  final MyFilesViewMode viewMode;
  final ValueChanged<MyFilesSort> onSortChanged;
  final ValueChanged<MyFilesViewMode> onViewModeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.myFiles,
            key: const Key('myFilesTitle'),
            style: AppTypography.myFilesTitle,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: AppSizes.myFilesControlsHeight,
            child: Row(
              children: [
                _SortPopup(sort: sort, onChanged: onSortChanged),
                const SizedBox(width: AppSpacing.sm),
                _ViewPopup(viewMode: viewMode, onChanged: onViewModeChanged),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SortPopup extends StatelessWidget {
  const _SortPopup({required this.sort, required this.onChanged});

  final MyFilesSort sort;
  final ValueChanged<MyFilesSort> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final criterion = switch (sort) {
      MyFilesSort.nameAscending || MyFilesSort.nameDescending => l10n.sortName,
      MyFilesSort.modifiedNewest ||
      MyFilesSort.modifiedOldest => l10n.sortModified,
      MyFilesSort.sizeSmallest || MyFilesSort.sizeLargest => l10n.sortFileSize,
    };
    final arrowDown = switch (sort) {
      MyFilesSort.nameDescending ||
      MyFilesSort.modifiedNewest ||
      MyFilesSort.sizeLargest => true,
      _ => false,
    };

    return PopupMenuButton<MyFilesSort>(
      key: const Key('myFilesSortButton'),
      initialValue: sort,
      tooltip: l10n.sort,
      color: AppColors.neutralBackground1,
      surfaceTintColor: AppColors.transparent,
      elevation: AppSizes.myFilesPopupElevation,
      constraints: const BoxConstraints(
        minWidth: AppSizes.myFilesPopupWidth,
        maxWidth: AppSizes.myFilesPopupWidth,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.myFilesPopup),
      ),
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final option in MyFilesSort.values)
          PopupMenuItem<MyFilesSort>(
            value: option,
            height: AppSizes.myFilesPopupItemHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                SizedBox(
                  width: AppSizes.myFilesPopupIconSize,
                  child: option == sort
                      ? const Icon(
                          Icons.check_rounded,
                          size: AppSizes.myFilesPopupIconSize,
                          color: AppColors.brandAccent,
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _sortOptionLabel(l10n, option),
                    style: AppTypography.myFilesPopupItem,
                  ),
                ),
              ],
            ),
          ),
      ],
      child: _ControlPill(
        label: criterion,
        leading: Icon(
          arrowDown ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
          size: AppSizes.myFilesPopupIconSize,
          color: AppColors.neutralForeground2,
        ),
      ),
    );
  }

  String _sortOptionLabel(AppLocalizations l10n, MyFilesSort option) {
    return switch (option) {
      MyFilesSort.nameAscending => '${l10n.sortName} · ${l10n.sortAtoZ}',
      MyFilesSort.nameDescending => '${l10n.sortName} · ${l10n.sortZtoA}',
      MyFilesSort.modifiedNewest =>
        '${l10n.sortModified} · ${l10n.sortNewestToOldest}',
      MyFilesSort.modifiedOldest =>
        '${l10n.sortModified} · ${l10n.sortOldestToNewest}',
      MyFilesSort.sizeSmallest =>
        '${l10n.sortFileSize} · ${l10n.sortSmallestToLargest}',
      MyFilesSort.sizeLargest =>
        '${l10n.sortFileSize} · ${l10n.sortLargestToSmallest}',
    };
  }
}

class _ViewPopup extends StatelessWidget {
  const _ViewPopup({required this.viewMode, required this.onChanged});

  final MyFilesViewMode viewMode;
  final ValueChanged<MyFilesViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<MyFilesViewMode>(
      key: const Key('myFilesViewButton'),
      initialValue: viewMode,
      tooltip: l10n.viewOptions,
      color: AppColors.neutralBackground1,
      surfaceTintColor: AppColors.transparent,
      elevation: AppSizes.myFilesPopupElevation,
      constraints: const BoxConstraints(
        minWidth: AppSizes.myFilesPopupWidth,
        maxWidth: AppSizes.myFilesPopupWidth,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.myFilesPopup),
      ),
      onSelected: onChanged,
      itemBuilder: (context) => [
        PopupMenuItem<MyFilesViewMode>(
          enabled: false,
          height: AppSizes.myFilesPopupHeaderHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(l10n.viewAs, style: AppTypography.myFilesPopupHeader),
        ),
        _viewItem(
          value: MyFilesViewMode.list,
          selected: viewMode == MyFilesViewMode.list,
          icon: Icons.view_list_outlined,
          label: l10n.viewList,
        ),
        _viewItem(
          value: MyFilesViewMode.icons,
          selected: viewMode == MyFilesViewMode.icons,
          icon: Icons.grid_view_outlined,
          label: l10n.viewIcons,
        ),
      ],
      child: _ControlPill(
        label: viewMode == MyFilesViewMode.list
            ? l10n.viewList
            : l10n.viewIcons,
        leading: Icon(
          viewMode == MyFilesViewMode.list
              ? Icons.view_list_outlined
              : Icons.grid_view_outlined,
          size: AppSizes.myFilesPopupIconSize,
          color: AppColors.neutralForeground2,
        ),
      ),
    );
  }

  PopupMenuItem<MyFilesViewMode> _viewItem({
    required MyFilesViewMode value,
    required bool selected,
    required IconData icon,
    required String label,
  }) {
    return PopupMenuItem<MyFilesViewMode>(
      value: value,
      height: AppSizes.myFilesPopupItemHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSizes.myFilesPopupIconSize,
            color: AppColors.neutralForeground1,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTypography.myFilesPopupItem)),
          if (selected)
            const Icon(
              Icons.check_rounded,
              size: AppSizes.myFilesPopupIconSize,
              color: AppColors.brandAccent,
            ),
        ],
      ),
    );
  }
}

class _ControlPill extends StatelessWidget {
  const _ControlPill({required this.label, required this.leading});

  final String label;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.myFilesControlsHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralBackground2,
        borderRadius: BorderRadius.circular(AppRadius.myFilesControl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading,
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTypography.myFilesControl),
          const SizedBox(width: AppSpacing.xxs),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: AppSizes.myFilesPopupIconSize,
            color: AppColors.neutralForeground2,
          ),
        ],
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView({
    required this.items,
    required this.displayName,
    required this.metadata,
    required this.onMore,
  });

  final List<DriveItem> items;
  final String Function(DriveItem item) displayName;
  final String Function(DriveItem item) metadata;
  final ValueChanged<DriveItem> onMore;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const Key('myFilesList'),
      padding: const EdgeInsets.only(
        bottom: AppSizes.myFilesBottomOverlayInset,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _ListRow(
          item: item,
          displayName: displayName(item),
          metadata: metadata(item),
          onMore: item.isPersonalVault || !item.hasActions
              ? null
              : () => onMore(item),
        );
      },
    );
  }
}

class _ListRow extends StatelessWidget {
  const _ListRow({
    required this.item,
    required this.displayName,
    required this.metadata,
    required this.onMore,
  });

  final DriveItem item;
  final String displayName;
  final String metadata;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      key: Key('myFilesRow-${item.id}'),
      height: AppSizes.myFilesListRowHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  const SizedBox(width: AppSpacing.sm),
                  DriveItemIcon(item: item, size: AppSizes.myFilesItemIconSize),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.myFilesRowTitle,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          metadata,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.myFilesRowMetadata,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: AppSizes.myFilesItemActionWidth + AppSpacing.xs,
                    child: onMore == null
                        ? null
                        : SizedBox.square(
                            dimension: AppSizes.myFilesItemActionWidth,
                            child: IconButton(
                              key: Key('myFilesMore-${item.id}'),
                              tooltip: l10n.moreActionsForItem(displayName),
                              onPressed: onMore,
                              icon: const Icon(
                                Icons.more_vert_rounded,
                                size: AppSizes.myFilesItemActionIconSize,
                                color: AppColors.neutralForeground2,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            start: AppSizes.myFilesRowDividerStart,
            end: AppSpacing.lg,
            bottom: 0,
            child: const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.neutralStroke2,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconGrid extends StatelessWidget {
  const _IconGrid({
    required this.items,
    required this.displayName,
    required this.metadata,
    required this.onMore,
  });

  final List<DriveItem> items;
  final String Function(DriveItem item) displayName;
  final String Function(DriveItem item) metadata;
  final ValueChanged<DriveItem> onMore;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final usableWidth = constraints.maxWidth - AppSpacing.xxl;
        final calculated =
            ((usableWidth + AppSpacing.sm) /
                    (AppSizes.myFilesGridTileMinWidth + AppSpacing.sm))
                .floor();
        final columns = math.max(
          AppSizes.myFilesGridMinColumns,
          math.min(AppSizes.myFilesGridMaxColumns, calculated),
        );

        return GridView.builder(
          key: const Key('myFilesIcons'),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSizes.myFilesBottomOverlayInset,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisExtent: AppSizes.myFilesGridTileHeight,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _GridTile(
              item: item,
              displayName: displayName(item),
              metadata: metadata(item),
              onMore: item.isPersonalVault || !item.hasActions
                  ? null
                  : () => onMore(item),
            );
          },
        );
      },
    );
  }
}

class _GridTile extends StatelessWidget {
  const _GridTile({
    required this.item,
    required this.displayName,
    required this.metadata,
    required this.onMore,
  });

  final DriveItem item;
  final String displayName;
  final String metadata;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      key: Key('myFilesTile-${item.id}'),
      color: AppColors.neutralBackground2,
      borderRadius: BorderRadius.circular(AppRadius.myFilesGridTile),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DriveItemIcon(item: item, size: AppSizes.myFilesGridIconSize),
                  const Spacer(),
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.myFilesRowTitle,
                  ),
                  Text(
                    metadata,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.myFilesRowMetadata,
                  ),
                ],
              ),
              if (onMore != null)
                PositionedDirectional(
                  top: -AppSpacing.md,
                  end: -AppSpacing.md,
                  child: IconButton(
                    key: Key('myFilesTileMore-${item.id}'),
                    tooltip: l10n.moreActionsForItem(displayName),
                    onPressed: onMore,
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      size: AppSizes.myFilesItemActionIconSize,
                      color: AppColors.neutralForeground2,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  const _SearchPill();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PositionedDirectional(
      start: AppSpacing.lg,
      end: AppSizes.myFilesSearchFabClearance,
      bottom: AppSpacing.lg,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          key: const Key('myFilesSearch'),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          onTap: () {},
          child: Container(
            height: AppSizes.myFilesSearchHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.neutralBackground1,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              boxShadow: AppShadows.floating,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: AppSizes.myFilesSearchIconSize,
                  color: AppColors.neutralForeground2,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.searchYourFiles,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.myFilesControl.copyWith(
                      color: AppColors.neutralForeground2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateFab extends StatelessWidget {
  const _CreateFab({required this.expanded, required this.onPressed});

  final bool expanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PositionedDirectional(
      end: AppSpacing.lg,
      bottom: AppSpacing.lg,
      child: SizedBox.square(
        dimension: AppSizes.myFilesFabSize,
        child: FloatingActionButton(
          key: const Key('myFilesFab'),
          tooltip: l10n.createOrUpload,
          onPressed: onPressed,
          backgroundColor: AppColors.brandAccent,
          foregroundColor: AppColors.onBrand,
          elevation: AppSizes.myFilesFabElevation,
          child: AnimatedRotation(
            duration: AppMotion.normal,
            turns: expanded ? .125 : 0,
            child: const Icon(
              Icons.add_rounded,
              size: AppSizes.myFilesFabIconSize,
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateMenu extends StatelessWidget {
  const _CreateMenu();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PositionedDirectional(
      end: AppSpacing.lg,
      bottom: AppSizes.myFilesFabMenuBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _CreateAction(
            label: l10n.newFolder,
            icon: Icons.create_new_folder_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _CreateAction(
            label: l10n.uploadFiles,
            icon: Icons.upload_file_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _CreateAction(
            label: l10n.scan,
            icon: Icons.document_scanner_outlined,
          ),
        ],
      ),
    );
  }
}

class _CreateAction extends StatelessWidget {
  const _CreateAction({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.neutralBackground1,
            borderRadius: BorderRadius.circular(AppRadius.myFilesFabLabel),
            boxShadow: AppShadows.floating,
          ),
          child: Text(label, style: AppTypography.myFilesControl),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox.square(
          dimension: AppSizes.myFilesMiniFabSize,
          child: FloatingActionButton.small(
            heroTag: null,
            onPressed: () {},
            backgroundColor: AppColors.neutralBackground1,
            foregroundColor: AppColors.brandAccent,
            elevation: AppSizes.myFilesFabElevation,
            child: Icon(icon, size: AppSizes.myFilesPopupIconSize),
          ),
        ),
      ],
    );
  }
}

class _ItemActionsSheet extends StatefulWidget {
  const _ItemActionsSheet({
    required this.item,
    required this.title,
    required this.metadata,
  });

  final DriveItem item;
  final String title;
  final String metadata;

  @override
  State<_ItemActionsSheet> createState() => _ItemActionsSheetState();
}

class _ItemActionsSheetState extends State<_ItemActionsSheet> {
  static const double _handleWidth = 36;
  static const double _handleHeight = 4;
  static const double _previewSize = 72;
  static const double _topActionHeight = 72;
  static const double _actionIconSize = 24;

  bool _availableOffline = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final availableActions = widget.item.availableActions;
    final topActions = <_SheetAction>[
      if (availableActions.contains(DriveItemAction.share))
        _SheetAction(Icons.ios_share_outlined, l10n.shareCommand),
      if (availableActions.contains(DriveItemAction.delete))
        _SheetAction(Icons.delete_outline, l10n.deleteCommand),
      if (availableActions.contains(DriveItemAction.download))
        _SheetAction(Icons.download_outlined, l10n.download),
    ];
    final bottomActions = <_SheetAction>[
      if (availableActions.contains(DriveItemAction.rename))
        _SheetAction(Icons.edit_outlined, l10n.rename),
      if (availableActions.contains(DriveItemAction.copy))
        _SheetAction(Icons.copy_outlined, l10n.copyCommand),
      if (availableActions.contains(DriveItemAction.move))
        _SheetAction(Icons.drive_file_move_outline, l10n.moveCommand),
      if (availableActions.contains(DriveItemAction.comments))
        _SheetAction(Icons.comment_outlined, l10n.comments),
      if (availableActions.contains(DriveItemAction.details))
        _SheetAction(Icons.info_outline, l10n.details),
    ];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          key: const Key('myFilesActionSheet'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              child: Container(
                width: _handleWidth,
                height: _handleHeight,
                decoration: BoxDecoration(
                  color: AppColors.neutralForeground2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(
              height: _previewSize,
              child: Center(
                child: DriveItemIcon(item: widget.item, size: _previewSize),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                widget.title,
                key: const Key('myFilesActionSheetName'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.myFilesPopupItem,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
              child: Text(
                widget.metadata,
                key: const Key('myFilesActionSheetMetadata'),
                textAlign: TextAlign.center,
                style: AppTypography.myFilesRowMetadata,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: _topActionHeight,
                child: Row(
                  key: const Key('myFilesActionSheetTopActions'),
                  children: [
                    for (final action in topActions)
                      Expanded(child: _buildTopAction(action)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (availableActions.contains(DriveItemAction.makeAvailableOffline))
              _buildOfflineAction(l10n.makeAvailableOffline),
            for (final action in bottomActions) _buildBottomAction(action),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAction(_SheetAction action) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Icon(
                    action.icon,
                    size: _actionIconSize,
                    color: AppColors.neutralForeground1,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    action.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTypography.myFilesRowMetadata.copyWith(
                      color: AppColors.neutralForeground1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineAction(String label) {
    return InkWell(
      key: const Key('myFilesActionSheetOffline'),
      onTap: () => setState(() => _availableOffline = !_availableOffline),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.cloud_download_outlined,
                    size: _actionIconSize,
                    color: AppColors.neutralForeground1,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.myFilesPopupItem.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Switch(
              value: _availableOffline,
              onChanged: (value) => setState(() => _availableOffline = value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(_SheetAction action) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              action.icon,
              size: _actionIconSize,
              color: AppColors.neutralForeground1,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                action.label,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.myFilesPopupItem.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetAction {
  const _SheetAction(this.icon, this.label);

  final IconData icon;
  final String label;
}
