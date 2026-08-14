import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:temp_bfe_android/features/auth/presentation/sign_in_screen.dart';
import 'package:temp_bfe_android/features/recycle_bin/presentation/recycle_bin_screen.dart';
import 'package:temp_bfe_android/l10n/app_localizations.dart';
import 'package:temp_bfe_android/theme/app_theme.dart';

void main() {
  testWidgets('renders signed-out screen in English', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SignInScreen(),
      ),
    );

    expect(
      find.text('Protect your files and access them anywhere'),
      findsOneWidget,
    );
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Skip to my photos'), findsOneWidget);
  });

  testWidgets('renders recycle bin in Russian', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('ru'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const RecycleBinScreen(),
      ),
    );

    expect(find.text('Корзина'), findsOneWidget);
    expect(find.text('УДАЛИТЬ ВСЕ'), findsOneWidget);
    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('Quarterly report.pdf'), findsOneWidget);
    expect(find.text('Budget 2026.xlsx'), findsOneWidget);
    expect(find.text('Contract.docx'), findsOneWidget);

    await tester.tap(find.byTooltip('Другие действия').first);
    await tester.pumpAndSettle();

    expect(find.text('Восстановить'), findsOneWidget);
    expect(find.text('Удалить'), findsOneWidget);
  });
}
