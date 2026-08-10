import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:temp_bfe_android/features/auth/presentation/sign_in_screen.dart';
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
}
