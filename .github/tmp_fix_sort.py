from pathlib import Path

p = Path('lib/features/my_files/presentation/my_files_screen.dart')
s = p.read_text()

old_enum = '''enum MyFilesSort {
  nameAscending,
  nameDescending,
  modifiedNewest,
  modifiedOldest,
  sizeSmallest,
  sizeLargest,
}
'''
new_enum = '''enum MyFilesSortField { name, modified, size }

enum MyFilesSortDirection { ascending, descending }

enum _MyFilesSortMenuChoice {
  name,
  modified,
  size,
  ascending,
  descending,
}
'''
if old_enum not in s:
    raise RuntimeError('sort enum block not found')
s = s.replace(old_enum, new_enum, 1)

old_state = '  MyFilesSort _sort = MyFilesSort.nameAscending;\n'
new_state = (
    '  MyFilesSortField _sortField = MyFilesSortField.name;\n'
    '  MyFilesSortDirection _sortDirection = MyFilesSortDirection.ascending;\n'
)
if old_state not in s:
    raise RuntimeError('sort state not found')
s = s.replace(old_state, new_state, 1)

old_header_call = '''                  _BrowserHeader(
                    sort: _sort,
                    viewMode: _viewMode,
                    onSortChanged: (value) => setState(() => _sort = value),
                    onViewModeChanged: (value) =>
                        setState(() => _viewMode = value),
                  ),'''
new_header_call = '''                  _BrowserHeader(
                    sortField: _sortField,
                    sortDirection: _sortDirection,
                    viewMode: _viewMode,
                    onSortFieldChanged: (value) =>
                        setState(() => _sortField = value),
                    onSortDirectionChanged: (value) =>
                        setState(() => _sortDirection = value),
                    onViewModeChanged: (value) =>
                        setState(() => _viewMode = value),
                  ),'''
if old_header_call not in s:
    raise RuntimeError('browser header call not found')
s = s.replace(old_header_call, new_header_call, 1)

start = s.index('  int _compareItems(DriveItem a, DriveItem b) {')
end = s.index('\n  String _displayName', start)
new_compare = '''  int _compareItems(DriveItem a, DriveItem b) {
    final aGroup = a.isFolder || a.isPersonalVault ? 0 : 1;
    final bGroup = b.isFolder || b.isPersonalVault ? 0 : 1;
    if (aGroup != bGroup) return aGroup.compareTo(bGroup);

    final comparison = switch (_sortField) {
      MyFilesSortField.name =>
        a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      MyFilesSortField.modified =>
        a.modifiedSortValue.compareTo(b.modifiedSortValue),
      MyFilesSortField.size => _compareSizes(a, b),
    };

    return _sortDirection == MyFilesSortDirection.ascending
        ? comparison
        : -comparison;
  }

  int _compareSizes(DriveItem a, DriveItem b) {
    if (a.sizeBytes == null || b.sizeBytes == null) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    }
    return a.sizeBytes!.compareTo(b.sizeBytes!);
  }
'''
s = s[:start] + new_compare + s[end:]

start = s.index('class _BrowserHeader extends StatelessWidget {')
end = s.index('\nclass _ViewPopup extends StatelessWidget {', start)
new_sort_classes = '''class _BrowserHeader extends StatelessWidget {
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
          case _MyFilesSortMenuChoice.ascending:
            onDirectionChanged(MyFilesSortDirection.ascending);
          case _MyFilesSortMenuChoice.descending:
            onDirectionChanged(MyFilesSortDirection.descending);
        }
      },
      itemBuilder: (context) => [
        _sortMenuItem(
          value: _MyFilesSortMenuChoice.name,
          label: l10n.sortName,
          selected: field == MyFilesSortField.name,
          key: const Key('myFilesSortField-name'),
        ),
        _sortMenuItem(
          value: _MyFilesSortMenuChoice.modified,
          label: l10n.sortModified,
          selected: field == MyFilesSortField.modified,
          key: const Key('myFilesSortField-modified'),
        ),
        _sortMenuItem(
          value: _MyFilesSortMenuChoice.size,
          label: l10n.sortFileSize,
          selected: field == MyFilesSortField.size,
          key: const Key('myFilesSortField-size'),
        ),
        const PopupMenuDivider(),
        _sortMenuItem(
          value: _MyFilesSortMenuChoice.ascending,
          label: l10n.sortAtoZ,
          selected: direction == MyFilesSortDirection.ascending,
          key: const Key('myFilesSortDirection-ascending'),
        ),
        _sortMenuItem(
          value: _MyFilesSortMenuChoice.descending,
          label: l10n.sortZtoA,
          selected: direction == MyFilesSortDirection.descending,
          key: const Key('myFilesSortDirection-descending'),
        ),
      ],
      child: _ControlPill(
        label: criterion,
        leading: Icon(
          direction == MyFilesSortDirection.ascending
              ? Icons.arrow_upward_rounded
              : Icons.arrow_downward_rounded,
          size: AppSizes.myFilesPopupIconSize,
          color: AppColors.neutralForeground2,
        ),
      ),
    );
  }

  PopupMenuItem<_MyFilesSortMenuChoice> _sortMenuItem({
    required _MyFilesSortMenuChoice value,
    required String label,
    required bool selected,
    required Key key,
  }) {
    return PopupMenuItem<_MyFilesSortMenuChoice>(
      key: key,
      value: value,
      height: AppSizes.myFilesPopupItemHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          SizedBox(
            width: AppSizes.myFilesPopupIconSize,
            child: selected
                ? const Icon(
                    Icons.check_rounded,
                    size: AppSizes.myFilesPopupIconSize,
                    color: AppColors.neutralForeground2,
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(label, style: AppTypography.myFilesPopupItem),
          ),
        ],
      ),
    );
  }
}
'''
s = s[:start] + new_sort_classes + s[end:]
p.write_text(s)

t = Path('test/my_files_screen_test.dart')
ts = t.read_text()
marker = "  testWidgets('View as switches List to Icons', (tester) async {\n"
test = """  testWidgets('sort popup matches OneDrive two-group contract', (tester) async {
    await pumpMyFiles(tester);

    await tester.tap(find.byKey(const Key('myFilesSortButton')));
    await tester.pumpAndSettle();

    expect(find.text('Name'), findsWidgets);
    expect(find.text('Modified'), findsOneWidget);
    expect(find.text('File size'), findsOneWidget);
    expect(find.text('A–Z'), findsOneWidget);
    expect(find.text('Z–A'), findsOneWidget);
    expect(find.textContaining('Name ·'), findsNothing);
    expect(find.textContaining('Modified ·'), findsNothing);
    expect(find.byType(PopupMenuDivider), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));
  });

  testWidgets('sort field and direction are independently selectable', (tester) async {
    await pumpMyFiles(tester);

    await tester.tap(find.byKey(const Key('myFilesSortButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('myFilesSortField-modified')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('myFilesSortButton')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const Key('myFilesSortField-modified')),
        matching: find.byIcon(Icons.check_rounded),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('myFilesSortDirection-ascending')),
        matching: find.byIcon(Icons.check_rounded),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('myFilesSortDirection-descending')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('myFilesSortButton')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const Key('myFilesSortField-modified')),
        matching: find.byIcon(Icons.check_rounded),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('myFilesSortDirection-descending')),
        matching: find.byIcon(Icons.check_rounded),
      ),
      findsOneWidget,
    );
  });

"""
if marker not in ts:
    raise RuntimeError('test insertion marker missing')
ts = ts.replace(marker, test + marker, 1)
t.write_text(ts)
