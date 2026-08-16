import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:temp_bfe_android/features/my_files/data/mock_drive_items.dart';
import 'package:temp_bfe_android/features/my_files/domain/drive_item.dart';
import 'package:temp_bfe_android/features/my_files/presentation/my_files_screen.dart';
import 'package:temp_bfe_android/l10n/app_localizations.dart';
import 'package:temp_bfe_android/theme/app_sizes.dart';
import 'package:temp_bfe_android/theme/app_theme.dart';

void main() {
  Future<void> pumpMyFiles(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    List<DriveItem> items = mockDriveItems,
    Size viewSize = const Size(390, 844),
  }) async {
    tester.view.physicalSize = viewSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        theme: AppTheme.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: MyFilesScreen(items: items),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('mock data covers folders and common file types', () {
    final kinds = mockDriveItems.map((item) => item.kind).toSet();
    expect(kinds, contains(DriveItemKind.folder));
    expect(kinds, contains(DriveItemKind.personalVault));
    expect(kinds, contains(DriveItemKind.pdf));
    expect(kinds, contains(DriveItemKind.excel));
    expect(kinds, contains(DriveItemKind.word));
    expect(kinds, contains(DriveItemKind.powerPoint));
    expect(kinds, contains(DriveItemKind.photo));
    expect(kinds, contains(DriveItemKind.text));
    expect(kinds, contains(DriveItemKind.video));
  });

  for (final locale in const [Locale('en'), Locale('ru')]) {
    testWidgets('My Files builds in ${locale.languageCode}', (tester) async {
      await pumpMyFiles(tester, locale: locale);
      expect(find.byKey(const Key('myFilesScreen')), findsOneWidget);
      expect(find.byKey(const Key('myFilesTitle')), findsOneWidget);
      expect(find.byKey(const Key('myFilesList')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('list row keeps 60dp Android height', (tester) async {
    await pumpMyFiles(tester);
    final row = find.byKey(const Key('myFilesRow-folder-1c'));
    expect(row, findsOneWidget);
    expect(tester.getSize(row).height, AppSizes.myFilesListRowHeight);
  });

  testWidgets('Russian labels come from l10n', (tester) async {
    await pumpMyFiles(tester, locale: const Locale('ru'));
    expect(find.text('Файлы'), findsOneWidget);
    expect(find.text('Мои файлы'), findsWidgets);
    expect(find.text('Поиск ваших файлов'), findsOneWidget);
    expect(find.text('Личный сейф'), findsWidgets);
  });

  testWidgets('View as switches List to Icons', (tester) async {
    await pumpMyFiles(tester);
    expect(find.byKey(const Key('myFilesList')), findsOneWidget);

    await tester.tap(find.byKey(const Key('myFilesViewButton')));
    await tester.pumpAndSettle();
    expect(find.text('View as'), findsOneWidget);
    await tester.tap(find.text('Icons').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('myFilesList')), findsNothing);
    expect(find.byKey(const Key('myFilesIcons')), findsOneWidget);
  });

  testWidgets('create FAB exposes root actions', (tester) async {
    await pumpMyFiles(tester, locale: const Locale('ru'));
    await tester.tap(find.byKey(const Key('myFilesFab')));
    await tester.pumpAndSettle();

    expect(find.text('Новая папка'), findsOneWidget);
    expect(find.text('Загрузить файлы'), findsOneWidget);
    expect(find.text('Сканировать'), findsOneWidget);
  });

  testWidgets('PDF more button opens OneDrive file action sheet', (
    tester,
  ) async {
    final pdf = mockDriveItems.singleWhere(
      (item) => item.id == 'quarterly-report',
    );
    await pumpMyFiles(tester, items: <DriveItem>[pdf]);

    final more = find.byKey(const Key('myFilesMore-quarterly-report'));
    expect(more, findsOneWidget);
    await tester.tap(more);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('myFilesActionSheet')), findsOneWidget);
    expect(find.byKey(const Key('myFilesActionSheetName')), findsOneWidget);
    expect(find.byKey(const Key('myFilesActionSheetMetadata')), findsOneWidget);
    expect(
      find.byKey(const Key('myFilesActionSheetTopActions')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('myFilesActionSheetOffline')), findsOneWidget);
    expect(
      tester
          .getSize(find.byKey(const Key('myFilesActionSheetTopActions')))
          .height,
      72,
    );
    expect(find.text('Quarterly report.pdf'), findsWidgets);
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    expect(find.text('Download'), findsOneWidget);
    expect(find.text('Make available offline'), findsOneWidget);
    expect(find.text('Rename'), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Move'), findsOneWidget);
    expect(find.text('Comments'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    expect(tester.widget<Text>(find.text('Share')).style?.fontSize, 12);
    expect(tester.widget<Text>(find.text('Rename')).style?.fontSize, 16);
  });

  testWidgets('Details action opens My Files details screen', (tester) async {
    final pdf = mockDriveItems.singleWhere(
      (item) => item.id == 'quarterly-report',
    );
    await pumpMyFiles(tester, items: <DriveItem>[pdf]);

    await tester.tap(find.byKey(const Key('myFilesMore-quarterly-report')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Details'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('myFilesActionSheet')), findsNothing);
    expect(find.byKey(const Key('myFilesDetailsScreen')), findsOneWidget);
    expect(find.byKey(const Key('myFilesDetailsName')), findsOneWidget);
    expect(find.text('Quarterly report.pdf'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('action sheet follows explicit operation capabilities', (
    tester,
  ) async {
    const folder = DriveItem(
      id: 'capability-folder',
      name: 'Capability folder',
      kind: DriveItemKind.folder,
      modified: DriveItemModifiedTime.oneHourAgo,
      modifiedSortValue: 1,
      itemCount: 1,
      availableActions: <DriveItemAction>[
        DriveItemAction.share,
        DriveItemAction.details,
      ],
    );
    await pumpMyFiles(tester, items: const <DriveItem>[folder]);

    await tester.tap(find.byKey(const Key('myFilesMore-capability-folder')));
    await tester.pumpAndSettle();

    expect(find.text(folder.name), findsWidgets);
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Delete'), findsNothing);
    expect(find.text('Download'), findsNothing);
    expect(find.text('Make available offline'), findsNothing);
    expect(find.text('Rename'), findsNothing);
    expect(find.text('Copy'), findsNothing);
    expect(find.text('Move'), findsNothing);
    expect(find.text('Comments'), findsNothing);
  });

  testWidgets('file actions do not overflow on compact Android height', (
    tester,
  ) async {
    final video = mockDriveItems.singleWhere((item) => item.id == 'demo-video');
    await pumpMyFiles(
      tester,
      items: <DriveItem>[video],
      viewSize: const Size(390, 650),
    );

    await tester.tap(find.byKey(const Key('myFilesMore-demo-video')));
    await tester.pumpAndSettle();

    expect(find.text('Demo video.mp4'), findsWidgets);
    expect(find.text('Delete'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
