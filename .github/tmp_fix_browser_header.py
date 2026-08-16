from pathlib import Path

p = Path('lib/features/my_files/presentation/my_files_screen.dart')
s = p.read_text()

s = s.replace('enum MyFilesSortDirection { ascending, descending }', 'enum MyFilesSortDirection { primary, secondary }', 1)
s = s.replace('enum _MyFilesSortMenuChoice { name, modified, size, ascending, descending }', 'enum _MyFilesSortMenuChoice { name, modified, size, primary, secondary }', 1)
s = s.replace('  MyFilesSortDirection _sortDirection = MyFilesSortDirection.ascending;', '  MyFilesSortDirection _sortDirection = MyFilesSortDirection.primary;', 1)

old_compare = '''    final comparison = switch (_sortField) {
      MyFilesSortField.name => a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      ),
      MyFilesSortField.modified => a.modifiedSortValue.compareTo(
        b.modifiedSortValue,
      ),
      MyFilesSortField.size => _compareSizes(a, b),
    };

    return _sortDirection == MyFilesSortDirection.ascending
        ? comparison
        : -comparison;'''
new_compare = '''    final primaryComparison = switch (_sortField) {
      MyFilesSortField.name => a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      ),
      MyFilesSortField.modified => b.modifiedSortValue.compareTo(
        a.modifiedSortValue,
      ),
      MyFilesSortField.size => _compareSizes(a, b),
    };

    return _sortDirection == MyFilesSortDirection.primary
        ? primaryComparison
        : -primaryComparison;'''
if old_compare not in s:
    raise RuntimeError('compare block not found')
s = s.replace(old_compare, new_compare, 1)

start = s.index('class _BrowserHeader extends StatelessWidget {')
end = s.index('\nclass _ListView extends StatelessWidget {', start)
replacement = '''class _BrowserHeader extends StatelessWidget {
  const _BrowserHeader({
    required this.sortField,
    required this.sortDirection,
    required this.viewMode,
    required this.onSortFieldChanged,
    required this.onSortDirectionChanged,
    required this.onViewModeChanged,
  });

  final MyFilesSortField sortField;
  final MyFilesSortDirection sortDirection;
  final MyFilesViewMode viewMode;
  final ValueChanged<MyFilesSortField> onSortFieldChanged;
  final ValueChanged<MyFilesSortDirection> onSortDirectionChanged;
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
                _SortPopup(
                  field: sortField,
                  direction: sortDirection,
                  onFieldChanged: onSortFieldChanged,
                  onDirectionChanged: onSortDirectionChanged,
                ),
                const Spacer(),
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
  const _SortPopup({
    required this.field,
    required this.direction,
    required this.onFieldChanged,
    required this.onDirectionChanged,
  });

  final MyFilesSortField field;
  final MyFilesSortDirection direction;
  final ValueChanged<MyFilesSortField> onFieldChanged;
  final ValueChanged<MyFilesSortDirection> onDirectionChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final criterion = switch (field) {
      MyFilesSortField.name => l10n.sortName,
      MyFilesSortField.modified => l10n.sortModified,
      MyFilesSortField.size => l10n.sortFileSize,
    };
    final primaryLabel = switch (field) {
      MyFilesSortField.name => l10n.sortAtoZ,
      MyFilesSortField.modified => l10n.sortNewestToOldest,
      MyFilesSortField.size => l10n.sortSmallestToLargest,
    };
    final secondaryLabel = switch (field) {
      MyFilesSortField.name => l10n.sortZtoA,
      MyFilesSortField.modified => l10n.sortOldestToNewest,
      MyFilesSortField.size => l10n.sortLargestToSmallest,
    };

    return PopupMenuButton<_MyFilesSortMenuChoice>(
      key: const Key('myFilesSortButton'),
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
      onSelected: (choice) {
        switch (choice) {
          case _MyFilesSortMenuChoice.name:
            onFieldChanged(MyFilesSortField.name);
          case _MyFilesSortMenuChoice.modified:
            onFieldChanged(MyFilesSortField.modified);
          case _MyFilesSortMenuChoice.size:
            onFieldChanged(MyFilesSortField.size);
          case _MyFilesSortMenuChoice.primary:
            onDirectionChanged(MyFilesSortDirection.primary);
          case _MyFilesSortMenuChoice.secondary:
            onDirectionChanged(MyFilesSortDirection.secondary);
        }
      },
      itemBuilder: (context) => [
        _sortMenuItem(value: _MyFilesSortMenuChoice.name, label: l10n.sortName, selected: field == MyFilesSortField.name, key: const Key('myFilesSortField-name')),
        _sortMenuItem(value: _MyFilesSortMenuChoice.modified, label: l10n.sortModified, selected: field == MyFilesSortField.modified, key: const Key('myFilesSortField-modified')),
        _sortMenuItem(value: _MyFilesSortMenuChoice.size, label: l10n.sortFileSize, selected: field == MyFilesSortField.size, key: const Key('myFilesSortField-size')),
        const PopupMenuDivider(),
        _sortMenuItem(value: _MyFilesSortMenuChoice.primary, label: primaryLabel, selected: direction == MyFilesSortDirection.primary, key: const Key('myFilesSortDirection-primary')),
        _sortMenuItem(value: _MyFilesSortMenuChoice.secondary, label: secondaryLabel, selected: direction == MyFilesSortDirection.secondary, key: const Key('myFilesSortDirection-secondary')),
      ],
      child: Row(
        key: const Key('myFilesSortControl'),
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(criterion, style: AppTypography.myFilesControl),
          const SizedBox(width: AppSpacing.xxs),
          Icon(
            direction == MyFilesSortDirection.primary ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
            size: AppSizes.myFilesPopupIconSize,
            color: AppColors.neutralForeground2,
          ),
        ],
      ),
    );
  }

  PopupMenuItem<_MyFilesSortMenuChoice> _sortMenuItem({required _MyFilesSortMenuChoice value, required String label, required bool selected, required Key key}) {
    return PopupMenuItem<_MyFilesSortMenuChoice>(
      key: key,
      value: value,
      height: AppSizes.myFilesPopupItemHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          SizedBox(
            width: AppSizes.myFilesPopupIconSize,
            child: selected ? const Icon(Icons.check_rounded, size: AppSizes.myFilesPopupIconSize, color: AppColors.neutralForeground2) : null,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTypography.myFilesPopupItem)),
        ],
      ),
    );
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
      constraints: const BoxConstraints(minWidth: AppSizes.myFilesPopupWidth, maxWidth: AppSizes.myFilesPopupWidth),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.myFilesPopup)),
      onSelected: onChanged,
      itemBuilder: (context) => [
        PopupMenuItem<MyFilesViewMode>(enabled: false, height: AppSizes.myFilesPopupHeaderHeight, padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg), child: Text(l10n.viewAs, style: AppTypography.myFilesPopupHeader)),
        _viewItem(value: MyFilesViewMode.list, selected: viewMode == MyFilesViewMode.list, icon: Icons.view_list_outlined, label: l10n.viewList),
        _viewItem(value: MyFilesViewMode.icons, selected: viewMode == MyFilesViewMode.icons, icon: Icons.grid_view_outlined, label: l10n.viewIcons),
      ],
      child: const SizedBox.square(
        dimension: AppSizes.myFilesControlsHeight,
        child: Icon(Icons.tune_rounded, key: Key('myFilesViewOptionsIcon'), size: AppSizes.myFilesPopupIconSize, color: AppColors.neutralForeground2),
      ),
    );
  }

  PopupMenuItem<MyFilesViewMode> _viewItem({required MyFilesViewMode value, required bool selected, required IconData icon, required String label}) {
    return PopupMenuItem<MyFilesViewMode>(
      value: value,
      height: AppSizes.myFilesPopupItemHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.myFilesPopupIconSize, color: AppColors.neutralForeground1),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTypography.myFilesPopupItem)),
          if (selected) const Icon(Icons.check_rounded, size: AppSizes.myFilesPopupIconSize, color: AppColors.brandAccent),
        ],
      ),
    );
  }
}
'''
s = s[:start] + replacement + s[end:]
p.write_text(s)

t = Path('test/my_files_screen_test.dart')
ts = t.read_text()
ts = ts.replace('myFilesSortDirection-ascending', 'myFilesSortDirection-primary')
ts = ts.replace('myFilesSortDirection-descending', 'myFilesSortDirection-secondary')
marker = "  testWidgets('View as switches List to Icons', (tester) async {\n"
extra = '''  testWidgets('sort direction labels follow selected field', (tester) async {
    await pumpMyFiles(tester);
    await tester.tap(find.byKey(const Key('myFilesSortButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('myFilesSortField-modified')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('myFilesSortButton')));
    await tester.pumpAndSettle();
    expect(find.text('Newest to oldest'), findsOneWidget);
    expect(find.text('Oldest to newest'), findsOneWidget);
    expect(find.text('A to Z'), findsNothing);
    expect(find.text('Z to A'), findsNothing);
  });

  testWidgets('browser header uses plain sort control and sliders view button', (tester) async {
    await pumpMyFiles(tester);
    expect(find.byKey(const Key('myFilesSortControl')), findsOneWidget);
    expect(find.byKey(const Key('myFilesViewOptionsIcon')), findsOneWidget);
  });

'''
if marker not in ts:
    raise RuntimeError('test marker missing')
ts = ts.replace(marker, extra + marker, 1)
t.write_text(ts)
